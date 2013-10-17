#!/usr/bin/ruby

#
# orca_make_new_prediction_from_recording
#
# A script that talks to the orchive server and runs bextract and sfplugin
# to classify a recording.
#
# We get a list of annotations from the server and this script creates the 
# required .mtl files and the main .mf file.
#
# We then run bextract on the .mf file and then run sfplugin on the
# output of bextract.
#
# We then send the resulting data back to the server
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


# Development
#WEB_SERVER = 'orchive.sness.org'
#WEB_SERVER_PORT = 80
#WEB_SERVER = 'localhost'
#WEB_SERVER_PORT = 3000

# Production
WEB_SERVER = 'orchive.cs.uvic.ca'
WEB_SERVER_PORT = 80

require 'net/http'
require 'uri'
require 'pp'

if ARGV[0] == nil
  abort("Usage: orca_make_new_prediction prediction_id")
else
  prediction_id = ARGV[0]
end

def build_mtl(outfile,annotations,labels,sorted_labels)
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
      #f.puts labels.index(n[:label])
      f.puts sorted_labels.index(n[:label])
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
Net::HTTP.start( WEB_SERVER, WEB_SERVER_PORT ) do |http|
  a = http.get("/predictions/show_annotations/#{prediction_id}.txt").body
  a.each do |n|
    b = n.split(",")
    h = {}
    label = b[0]
    start_time_samples = (b[1].to_i * 44.1).to_i
    end_time_samples = (b[2].to_i * 44.1).to_i
    recording = b[3].chomp

    h[:label] = label
    h[:start_time_samples] = start_time_samples
    h[:end_time_samples] = end_time_samples
    h[:recording] = recording

    annotations << h
    recordings << recording
    labels << label
  end
end

sorted_labels = labels.sort.uniq

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
  build_mtl(File.basename(k)[0..-5],a,labels,sorted_labels)
end

#
# Build a .mf file for each unique recording
#
mtl_file = ""
File.open("out.mf","w") do |f|
  recording_annotations.each do |k,v|
    mtl_file = "#{File.basename(k)[0..-5]}.mtl"
    f.puts "#{k}\t#{mtl_file}"
  end
end

#
# Run bextract on this .mf file
#
puts "Running bextract"
`/play/orchive/bin/bextract -pm -mfcc -t out.mf -w out.arff -p out.mpl`
#`/play/orchive/bin/bextract -mfcc -t out.mf -w out.arff -p out.mpl`

#
# Run sfplugin on the output .mpl file and the original recording
#
puts "Running sfplugin"
input_wavfile_name = recording_annotations.sort[0][0]
`/play/orchive/bin/sfplugin -p out.mpl #{input_wavfile_name} > out.txt`

#
# Convert the output of sfplugin to something that the web server can understand
#
sfplugin_output = []
File::open("out.txt", "r" ) do |f|
  begin
    f.each_line do |line|
      a = line.split
      sfplugin_output << a
    end
  end
end

times = []
(1...sfplugin_output.length).each do |i|
  a = {}
  a[:start] = (sfplugin_output[i-1][0].to_f * 1000.0).to_i
  a[:end] = (sfplugin_output[i][0].to_f * 1000.0).to_i
  times << a
end

output = []
(0...sfplugin_output.length-1).each do |i|
  id = i + 1
  start_ms = times[i][:start]
  end_ms = times[i][:end]
  label = sfplugin_output[i][1]
  confidence = (sfplugin_output[i][2].to_f / 100.0)

  if (label == "orca")
    color = "0x00FF00"
  elsif (label == "bg")
    color = "0xFFFFFF"
  elsif (label == "vn")
    color = "0x0000FF"
  elsif (label == "N4")
    color = "0xFF00FF"
  elsif (label == "N47")
    color = "0x00FFFF"
  elsif (label == "N1-A30")
    color = "0xFF0000"
  elsif (label == "N7-A30")
    color = "0xFFFF00"
  else
    color = "0xFFFF00"
  end
  
  a = "#{id},#{start_ms},#{end_ms},#{label},#{confidence},#{color}"
  output << a
end

output_string = ""
output.each do |n|
  output_string += "#{n}\n"
end

pp output_string.size

puts "Uploading data to web server"
res,data = Net::HTTP.post_form(URI.parse("http://#{WEB_SERVER}:#{WEB_SERVER_PORT}/predictions/update_data/#{prediction_id}"),{'data' => output_string})
pp res
pp data
