require 'pp'

class AdminAccountsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_required

  layout 'admin'

  def index
    @users = User.find(:all)
  end

end
