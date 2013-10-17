class AdminPredictionsController < ApplicationController

  include AuthenticatedSystem
  layout 'admin'

  def index
    @predictions = Prediction.find(:all)
  end

  def show
    @prediction = Prediction.find(params[:id])
  end
  
end
