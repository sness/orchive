# == Schema Information
# Schema version: 20100420092914
#
# Table name: recordings
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)     
#  tape                :string(255)     
#  side                :string(255)     
#  year                :integer(4)      
#  start_time          :datetime        
#  end_time            :datetime        
#  length_ms           :integer(4)      
#  wav_audio_file_path :string(255)     
#  mp3_audio_file_path :string(255)     
#  created_at          :datetime        
#  updated_at          :datetime        
#

class Recording < ActiveRecord::Base

  # sness - Just one annotation per user per recording for now
  has_many :annotations
  has_many :predictions
  has_many :visualizations

  has_many :labbook_page_recordings
  has_many :labbook_pages, :through => :labbook_page_recordings
  
  has_many :recording_comments

  def pretty_name
    out = ""
    if !year.nil? && !tape.nil? && !side.nil?
      out = "#{year} #{tape.rjust(3,'0')}#{side}"
    else
      out = "---"
    end
    return out
  end

  def year_tape_side
#    return "#{year}/#{tape.rjust(3,'0')}#{side}"
#    return "#{year}/#{tape}#{side}"
    
    return name.gsub(/[_]/, '/')
  end

  def self.number_digitized(year)
    count(:all, :conditions => {:year => year})
  end

  def self.max_digitized_in_a_year
    max = 0
    y = Year.find(:all)
    y.each do |n|
      r = Recording.number_digitized(n.name)
      if max < r
        max = r
      end
    end
    return max
  end

  def start_year
    if start_time.nil?
      return 1923
    else
      return start_time.year
    end
  end

  def start_month
    if start_time.nil?
      return 01
    else
      return start_time.month
    end
  end
  def start_day
    if start_time.nil?
      return 01
    else
      return start_time.day
    end
  end

  def start_hour
    if start_time.nil?
      return 0
    else
      return start_time.hour
    end
  end

  def start_minute
    if start_time.nil?
      return 00
    else
      return start_time.min
    end
  end

  def incidences
    # sness - need to fix this later to account for tapes that start on 
    # one day and finish on the next.
    if !start_time.nil?
      i = Incidence.find(:all, :conditions => {:date => start_time.to_date})
    else 
      i = []
    end
    return i
  end

  def user_annotations(user_id)
    return annotations.find(:all,:conditions => {:user_id => user_id})
  end

  def users
    a = annotations.find(:all)
    users = []
    a.each do |n|
      users.push(n.user)
    end
    return users.uniq
  end

  def user_predictions(user_id)
    return predictions.find(:all,:conditions => {:user_id => user_id})
  end

end
