# == Schema Information
# Schema version: 20100420092914
#
# Table name: classifiers
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  mpl        :text            
#  arff       :text            
#  user_id    :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#


class Classifier < ActiveRecord::Base

  belongs_to :user

  has_many :classifier_annotations
  has_many :annotations, :through => :classifier_annotations
  
  def completed?
    if !self.finished_at.nil?
      return true
    else
      return nil
    end
  end

  def self.per_page
    10
  end

  def to_text
    a = ""
    annotations.each do |n|
      a += "#{n.label},#{n.start_time_ms},#{n.end_time_ms},#{n.recording.wav_audio_file_path}\n"
    end
    return a
  end

end
