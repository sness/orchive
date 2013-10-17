class AccountController < ApplicationController

#  layout 'admin'

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    if (!request.post?)
      session[:return_to] = request.referrer
      return
    end
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
#      redirect_back_or_default(:controller => 'admin', :action => 'index')
      redirect_to session[:return_to]
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!  As soon as one of our admins approves your account, you can start making annotations."
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end

####################################################################################################

  #
  # Forgotten Password
  #
  def forgot_password
	if request.post?
	  @user = User.find_by_email(params[:forgot_password][:email])
	  if !@user
		flash[:notice] = 'Sorry, we could not find that email address in our files.'
		redirect_to :action => 'forgot_password'
	  else
		# Generate a new password
		new_password = rand(1000000000).to_s(16)
		# Encrypt password
		encrypted_password = @user.change_password(new_password)
		# Store new password in database
		@user.change_password(encrypted_password)
		@user.save!
		# Send email with new password
		email = ForgottenMailer.create_forgot_password(@user,new_password)
		email.set_content_type("text/html")
		ForgottenMailer::deliver(email)
		# Tell the user their password has been sent
		render :action => 'forgot_password_email_sent'
	  end
	end
  end

  #
  # Forgotten Username
  #
  def forgot_username
	if request.post?
	  @user = User.find_by_email(params[:forgot_username][:email])
	  if !@user
		flash[:notice] = 'Sorry, we could not find that email address in our files.'
		redirect_to :action => 'forgot_usernmae'
	  else
		# Send email with the username
		email = ForgottenMailer.create_forgot_username(@user)
		email.set_content_type("text/html")
		ForgottenMailer::deliver(email)
		# Tell the user their password has been sent
		render :action => 'forgot_username_email_sent'
	  end
	end
  end

  def change_password
	if request.post?
	  if params[:user][:password] != params[:user][:password_confirmation]
		flash[:notice] = 'The new password and the confirmation did not match'
		redirect_to :action => 'change_password'
	  elsif params[:user][:password].length < 5 || params[:user][:password].length > 40
		flash[:notice] = 'Your password must be longer than 5 characters and shorter than 40 characters'
		redirect_to :action => 'change_password'
	  elsif User.authenticate(self.current_user.login,params[:user][:current_password])
		self.current_user.change_password(params[:user][:password])
		self.current_user.save!
		flash[:notice] = 'Password successfully changed'
		redirect_to :action => 'index'
	  else
		flash[:notice] = 'The password you entered does not match the one we have on file'
		redirect_to :action => 'change_password'
	  end
	end
  end

  def edit
    @user = current_user
    if request.post?
      @user.attributes = params[:user]
      if @user.save!
        flash[:notice] = 'User was successfully submitted.'
        redirect_to :action => 'index'
      else
        flash[:notice] = 'Error in editting user.'
        render :action => 'edit_user', :id => params[:id]
      end
    end
  end
  
end
