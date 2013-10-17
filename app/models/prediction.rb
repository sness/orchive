# == Schema Information
# Schema version: 20100420092914
#
# Table name: predictions
#
#  id           :integer(4)      not null, primary key
#  data         :text(16777215)  
#  name         :string(255)     
#  status       :integer(4)      
#  user_id      :integer(4)      
#  recording_id :integer(4)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Prediction < ActiveRecord::Base

  belongs_to :user
  belongs_to :recording

  has_many :prediction_annotations
  has_many :annotations, :through => :prediction_annotations

  def to_string
    return "#{id},#{start_time_ms},#{end_time_ms},#{label}"
  end

  def pretty_status
    if status == 0
      return "not run"
    elsif status == 1
      return "in progress"
    elsif status == 2
      return "done"
    else
      return "unknown"
    end
  end

  def annotations_to_text
    a = ""
    annotations.each do |n|
      a += "#{n.label},#{n.start_time_ms},#{n.end_time_ms},#{n.recording.wav_audio_file_path}\n"
    end
    return a
  end

end
