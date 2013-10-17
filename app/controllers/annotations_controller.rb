require 'pp'

class AnnotationsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_from_cookie

  def show
    render :text => Annotation.find(params[:id]).data
  end

  # Receive updated annotations from the web server
  def update
    errors = []
    output = ""

    puts "**********"
    if (params[:user_id] == params[:annotation_user_id])
      # The output file from the server is in the params[:annotations] hash
      annotations = params[:annotations]
      # Split the file into lines
      annotations.split("\n").each do |n|
        # Split the line into fields
        fields = n.split(",")
        pp fields
        ann_id = fields[0]
        ann_start_ms = fields[1].to_i
        ann_end_ms = fields[2].to_i
        ann_label = fields[3]
        if (ann_label.nil?)
          Annotation.delete(ann_id)
          break
        end
        if (ann_id == "0")
          ann = Annotation.new()
        else
          ann = Annotation.find(ann_id)
        end
        ann.start_time_ms = ann_start_ms
        ann.end_time_ms = ann_end_ms
        ann.label = ann_label
        ann.recording_id = params[:recording_id]
        ann.user_id = params[:user_id]

        # Make sure not to create a duplicate entry if the user
        # already tried to save this, but the data hasn't been updated
        # in the OrcaAnnotator
        exists = Annotation.find(:first, :conditions => {
                                   :start_time_ms => ann_start_ms, 
                                   :end_time_ms => ann_end_ms, 
                                   :label => ann_label, 
                                   :recording_id => params[:recording_id], 
                                   :user_id => params[:user_id]})

        if exists.nil?
          if !ann.save
            errors << "error in saving annotation_id #{ann_id}";
          end
        end
      end

      output = errors.to_s
      annotations = Recording.find(params[:recording_id]).user_annotations(params[:user_id])
      annotations.each do |n|
        output += n.to_string + "\n"
      end
    else
      output = "wrong user tried to save their annotations"
    end

    pp output

    render :text => output

  end

end
