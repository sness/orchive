#!/usr/bin/ruby

#
# orca-build-classifier.rb
#
# A script that talks to the orchive server and runs bextract to build
# a classifier.  
#
# We get a list of annotations from the server and this script creates the 
# required .mtl files and the main .mf file.
#
# We then run bextract on the .mf file and send the resulting .mpl and
# .arff files back to the server.
#

#
# 	  The .mtl format has three header lines, followed by blocks of 4 lines
# 	  for each annotated section.  The format is:
#
# 	  HEADER:
# 	  -------
#	  
# 	  number of regions
# 	  line size (=1)
# 	  total size (samples)
#	  
# 	  FOR EACH SAMPLE:
# 	  ----------------
# 	  start (samples)
# 	  classId (mrs_natural)
# 	  end (samples)
# 	  name (mrs_string)
#	  
#	  
# 	  For example:
#	  
# 	  3
# 	  1
# 	  2758127
# 	  0   
# 	  0
# 	  800000
# 	  voiceover
# 	  800001
# 	  1
# 	  1277761
# 	  orca
# 	  1277762
# 	  2
# 	  2758127
# 	  background
#	  


require 'net/http'
require 'pp'

if ARGV[0] == nil
  abort("Usage: orca-build-classifier.rb classifier_id")
else
  classifier_id = ARGV[0]
end

def build_mtl(outfile,annotations,labels)
  puts "Building annotation for #{outfile}"
  File.open("#{outfile}.mtl","w") do |f|
    # Number of annotations
    f.puts annotations.length
    # line size (=1)
    f.puts "1"
    # Number of samples
    f.puts "126959622"
    
    # Output one block for each annotation
    annotations.each do |n|
      f.puts n[:start_time_samples]
      f.puts labels.index(n[:label])
      f.puts n[:end_time_samples]
      f.puts n[:label]
    end
  end
end

#
# Get the list of annotations from the web server
#
annotations = []
recordings = []
labels = []
Net::HTTP.start( 'orchive.sness.org', 80 ) do |http|
  a = http.get("/classifier/show/#{classifier_id}.txt").body
  a.each do |n|
    b = n.split(",")
    h = {}
    label = b[0]
    start_time_samples = (b[1].to_i * 44.1).to_i
    end_time_samples = (b[2].to_i * 44.1).to_i
    recording = "/Volumes/Orchive2/assets/#{b[3].chomp}"

    h[:label] = label
    h[:start_time_samples] = start_time_samples
    h[:end_time_samples] = end_time_samples
    h[:recording] = recording

    annotations << h
    recordings << recording
    labels << label
  end
end

#
# Figure out the unique recordings and build an array containing all
# the annotations that belong to that recording
#
recordings.uniq!
labels.uniq!

recording_annotations = {}
recordings.each do |recording|
  recording_annotations[recording] = []
  annotations.each do |annotation|
    if (annotation[:recording] == recording)
      recording_annotations[recording] << annotation
    end
  end
end

#
# Build a .mtl file for each unique recording
#
recording_annotations.each do |k,v|
  # Sort the annotations by their start time
  a = v.sort_by { |n| n[:start_time_samples] }
  # sness - The magic at the end gives us just "449B" from the whole
  # path to the recording
  build_mtl(File.basename(k)[0..-5],a,labels)
end

#
# Build a .mf file for each unique recording
#
File.open("out.mf","w") do |f|
  recording_annotations.each do |k,v|
    mtl_file = "#{File.basename(k)[0..-5]}.mtl"
    f.puts "#{k}\t#{mtl_file}"
  end
end
