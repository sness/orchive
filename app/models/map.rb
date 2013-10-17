# == Schema Information
# Schema version: 20100420092914
#
# Table name: maps
#
#  id                     :integer(4)      not null, primary key
#  date                   :date            
#  image_file_path        :string(255)     
#  medium_image_file_path :string(255)     
#  created_at             :datetime        
#  updated_at             :datetime        
#

class Map < ActiveRecord::Base
end
