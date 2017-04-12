class UserMailer < ApplicationMailer

  def reset_password_email(user)
    @user = User.find user.id
    subdomain = Apartment::Tenant.current
    @url  = edit_password_reset_url(@user.reset_password_token, subdomain: subdomain)
    mail(:to => user.email,
         :subject => "Your password has been reset")
  end

  def set_password_email(user, subdomain)
    Apartment::Tenant.switch! subdomain
    @user = user
    @url  = edit_password_reset_url(@user.reset_password_token, subdomain: subdomain)
    mail(:to => user.email,
         :subject => "Welcome to Ireland Pay")
  end
end
