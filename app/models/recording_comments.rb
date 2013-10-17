# == Schema Information
# Schema version: 20100420092914
#
# Table name: recording_comments
#
#  id           :integer(4)      not null, primary key
#  text         :text            
#  recording_id :integer(4)      
#  user_id      :integer(4)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class RecordingComments < ActiveRecord::Base

  belongs_to :recording
  belongs_to :user

end
