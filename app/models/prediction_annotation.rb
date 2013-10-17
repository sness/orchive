# == Schema Information
# Schema version: 20100420092914
#
# Table name: prediction_annotations
#
#  id            :integer(4)      not null, primary key
#  prediction_id :integer(4)      
#  annotation_id :integer(4)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class PredictionAnnotation < ActiveRecord::Base

  belongs_to :prediction
  belongs_to :annotation

end
