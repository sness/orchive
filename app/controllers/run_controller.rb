class RunController < ApplicationController

  def set_state_as_running
    if request.post?
      job = Job.find(params[:id])
      job.set_state_as_running
      job.save!
      render :text => 'state set as running'
    end
  end

  def set_state_as_completed_successfully
    if request.post?
      job = Job.find(params[:id])
      job.set_state_as_completed_successfully
      job.save!
      begin
        email = JobMailer.deliver_complete(job)
        render :text => 'state set as completed_successfully'
      rescue Net::SMTPFatalError
        logger.info("***Could not relay #{email}")
        render :text => 'state set as completed_successfully, but could not email'
      end
    end
  end

end
