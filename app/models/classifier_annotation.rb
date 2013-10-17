# == Schema Information
# Schema version: 20100420092914
#
# Table name: classifier_annotations
#
#  id            :integer(4)      not null, primary key
#  classifier_id :integer(4)      
#  annotation_id :integer(4)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class ClassifierAnnotation < ActiveRecord::Base

  belongs_to :classifier
  belongs_to :annotation

end
