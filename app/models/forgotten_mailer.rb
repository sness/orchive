class ForgottenMailer < ActionMailer::Base

  def forgot_password(user, new_password)
    @subject      = 'Forgot Password'
    @body["user"] = user
    @body["new_password"] = new_password
    @recipients   = user.email
    @from         = 'orchive@orchive.cs.uvic.ca'
    @sent_on      = Time.now
    @headers      = {}
  end

  def forgot_username(user)
    @subject      = 'Forgot Password'
    @body["user"] = user
    @recipients   = user.email
    @from         = 'orchive@orchive.cs.uvic.ca'
    @sent_on      = Time.now
    @headers      = {}
  end

end
