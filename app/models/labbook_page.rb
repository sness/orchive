# == Schema Information
# Schema version: 20100420092914
#
# Table name: labbook_pages
#
#  id                        :integer(4)      not null, primary key
#  start_date                :date            
#  end_date                  :date            
#  page                      :integer(4)      
#  image_file_path           :string(255)     
#  medium_image_file_path    :string(255)     
#  small_image_file_path     :string(255)     
#  thumbnail_image_file_path :string(255)     
#  page_text                 :text            
#  labbook_id                :integer(4)      
#  created_at                :datetime        
#  updated_at                :datetime        
#

class LabbookPage < ActiveRecord::Base

  belongs_to :labbook
  has_many :labbook_page_recordings
  has_many :recordings, :through => :labbook_page_recordings

  # sness - Hmm, this is just for displaying the _leftnav bar,
  # but somehow it feels a bit strange to do this. 
  def year
    return labbook.end_date.year 
  end


end
