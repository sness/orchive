# == Schema Information
# Schema version: 20100420092914
#
# Table name: labbook_page_recordings
#
#  id              :integer(4)      not null, primary key
#  labbook_page_id :integer(4)      
#  recording_id    :integer(4)      
#  user_id         :integer(4)      
#  created_at      :datetime        
#  updated_at      :datetime        
#

class LabbookPageRecording < ActiveRecord::Base

  belongs_to :labbook_page
  belongs_to :recording
  belongs_to :user

end
