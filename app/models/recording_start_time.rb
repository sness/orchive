# == Schema Information
# Schema version: 20100420092914
#
# Table name: recording_start_times
#
#  id           :integer(4)      not null, primary key
#  start_time   :datetime        
#  recording_id :integer(4)      
#  user_id      :integer(4)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class RecordingStartTime < ActiveRecord::Base
  belongs_to :recording
  belongs_to :user
end
