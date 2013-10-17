class AdminController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_required

  # Make sure that the user is an admin user before showing them the
  # admin pages
  before_filter :check_admin_user

  layout 'admin'

  def index
  end

  def make_a_prediction_on_one_annotation
    @annotations = Annotation.find(:all)
  end


  ##############################
  private

  def check_admin_user
    if !current_user || !current_user.admin
      redirect_to :controller => 'main', :action => 'index'
    end
  end

end
