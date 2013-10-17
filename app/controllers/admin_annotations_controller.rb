class AdminAnnotationsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_required

  layout 'admin'

  def index
    @annotations = Annotation.find(:all)
  end

  def show
    @annotation = Annotation.find(params[:id])
  end


end
