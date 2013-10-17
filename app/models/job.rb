# == Schema Information
# Schema version: 20100420092914
#
# Table name: jobs
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  state      :integer(4)      
#  user_id    :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

STATE_CREATED = 0
STATE_SUBMITTED_TO_SQS = 1
STATE_RUNNING = 2
STATE_COMPLETED_SUCCESSFULLY = 3
STATE_COMPLETED_WITH_ERROR = 4

class Job < ActiveRecord::Base

  belongs_to :user
  
  def pretty_state
    if state == STATE_CREATED
      return "Created"
    elsif state == STATE_SUBMITTED_TO_SQS
      return "Submitted"
    elsif state == STATE_RUNNING
      return "Running"
    elsif state = STATE_COMPLETED_SUCCESSFULLY
      return "Completed"
    elsif state = STATE_COMPLETED_WITH_ERROR
      return "Error"
    else
      return ""
    end
  end

  def send_job_to_sqs
    pp "***queue=#{SQS_QUEUE_NAME}"
    q = SQS.get_queue SQS_QUEUE_NAME
    a = q.send_message id
    self.sqs_id = a.id
    self.state = STATE_SUBMITTED_TO_SQS
    logger.info("***send_job_to_sqs***")
  end

  def set_state_as_running
    self.state = STATE_RUNNING
    logger.info("***set_state_as_running***")
  end

  def set_state_as_completed_successfully
    self.state = STATE_COMPLETED_SUCCESSFULLY
    self.finished_at = Time.now
    logger.info("***set_state_as_completed_successfully***")
  end

  def completed?
    if self.state == STATE_COMPLETED_SUCCESSFULLY || self.state == STATE_COMPLETED_WITH_ERROR
      return true
    else
      return nil
    end
  end

  def current_jobs
  end

  def self.per_page
    10
  end

end
