class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += I18n.t("mailer.user.signup_notification", :default => 'Please activate your new account')
    @body[:url]  = "http://#{APP_CONFIG.site_url}/activate/#{user.perishable_token}"
  end

  def reset_password(user)
    setup_email(user)
    @subject += I18n.t("mailer.user.reset_password", :default => "Your password has been reset")
    @body[:url]  = "http://#{APP_CONFIG.site_url}/login"
  end

  def forgot_password(user)
    setup_email(user)
    @subject += I18n.t("mailer.user.forgot_password", :default => "Forgotten password instructions")
    @body[:url]  = "http://#{APP_CONFIG.site_url}/users/reset_password/#{user.perishable_token}"
  end

  def forgot_login(user)
    setup_email(user)
    @subject += I18n.t("mailer.user.forgot_login", :default => "Forgotten account login")
    @body[:url]  = "http://#{APP_CONFIG.site_url}/login"
  end

  def activation(user)
    setup_email(user)
    @subject    += I18n.t("mailer.user.activation", :default => 'Your account has been activated!')
    @body[:url]  = "http://#{APP_CONFIG.site_url}/"
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{APP_CONFIG.support_name} <#{APP_CONFIG.support_email}>"
      @subject     = "[#{APP_CONFIG.site_name}] "
      @sent_on     = Time.now
      @body[:user] = user

      # Get Settings
      [:site_name, :company_name, :support_email, :support_name].each do |id|
        @body[id] = APP_CONFIG.send(id)
      end
    end
end

