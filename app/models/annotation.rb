# == Schema Information
# Schema version: 20100420092914
#
# Table name: annotations
#
#  id            :integer(4)      not null, primary key
#  start_time_ms :integer(4)      
#  end_time_ms   :integer(4)      
#  label         :string(255)     
#  comments      :text            
#  user_id       :integer(4)      
#  recording_id  :integer(4)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class Annotation < ActiveRecord::Base

  belongs_to :user
  belongs_to :recording

  has_many :classifier_annotations
  has_many :classifiers, :through => :classifier_annotations

  def to_string
    return "#{id},#{start_time_ms},#{end_time_ms},#{label}"
  end

  def to_audacity
    return "#{start_time_sec}\t#{end_time_sec}\t#{label}\n"
  end

  def start_time_sec
    return start_time_ms.to_f / 1000
  end

  def end_time_sec
    return end_time_ms.to_f / 1000
  end

end
