# == Schema Information
# Schema version: 20100420092914
#
# Table name: visualizations
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)     
#  params       :string(255)     
#  file_path    :string(255)     
#  recording_id :integer(4)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Visualization < ActiveRecord::Base
end
