# == Schema Information
# Schema version: 20100420092914
#
# Table name: years
#
#  id         :integer(4)      not null, primary key
#  name       :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

#
# You would think that we would just make a Recording and Labbook
# belong_to a Year, but at least Labbooks can span more than one Year,
# so I think it's better to just look up the recordings based on the
# year name and have the recording.year field be indexed
#

class Year < ActiveRecord::Base

  def self.labels
    h = {}
    years = Year.find(:all, :order => 'name')
    years.each_with_index do |n,i|
      if i % 1 == 0
        h[i] = n.name.to_s
      end
    end
    return h
  end

  def self.data
    years = Year.find(:all, :order => 'name')
    percents = []
    years.each do |n|
       percents << Recording.number_digitized(n.name)
    end
    return percents
  end

end
