require 'pp'

class AdminJobsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_required

  layout 'admin'

  def index
    @jobs = Job.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def show
    @job = Job.find(params[:id])
  end

  def submit_job_for_prediction_on_one_annotation
    # The annotation that we are submitting the job for
    @annotation = Annotation.find(params[:id])

    @job = Job.new
    if request.post?
      @job.attributes = params[:job]
      @job.script = "run_bextract_weka_bayes.rb"
      @job.input = ""
      @annotation.recordings.each do |n|
        @job.input += n.name + "\n";
      end
      if @job.save
        @job.send_job_to_sqs
        # sness - We should be doing some more error checking here
        @job.save!
        flash[:notice] = 'Job was successfully submitted.'
        redirect_to :action => 'index'
      else
        flash[:notice] = 'Error in creating job.'
        render :action => 'submit_job_for_prediction_on_one_annotation'
      end
    end

  end

end
