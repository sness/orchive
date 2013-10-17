# == Schema Information
# Schema version: 20100420092914
#
# Table name: incidences
#
#  id              :integer(4)      not null, primary key
#  date            :date            
#  identification  :string(255)     
#  acoustic_visual :string(255)     
#  location        :string(255)     
#  east_js         :string(255)     
#  qcs             :string(255)     
#  observer        :string(255)     
#  system_info     :string(255)     
#  effort          :string(255)     
#  comments        :string(255)     
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Incidence < ActiveRecord::Base

  def pretty_identification
    # sness - A hack to make the string wrap.  There is a better way
    # to do this.
    if identification.length > 30
      identification.insert(30, " ")
    end
  end
  
end
