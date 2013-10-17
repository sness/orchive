# == Schema Information
# Schema version: 20100420092914
#
# Table name: call_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class CallType < ActiveRecord::Base
end
