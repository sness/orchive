# == Schema Information
# Schema version: 20100420092914
#
# Table name: calls
#
#  id           :integer(4)      not null, primary key
#  matriline    :string(255)     
#  notes        :string(255)     
#  audio        :string(255)     
#  image        :string(255)     
#  call_type_id :integer(4)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Call < ActiveRecord::Base

  belongs_to :call_type

  def name
    if call_type.nil?
      return ""
    else
      return call_type.name
    end
  end

  def flash_name
    return "#{name} #{matriline}"
  end

end
