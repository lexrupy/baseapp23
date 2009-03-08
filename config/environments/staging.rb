# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Delivery method :test, :smtp, :sendmail
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'example.com',
  :authentication => :plain,
  :user_name => "support@example.com",
  :password => "0caaf24ab1a0c33440c06afe99df986365b0781f"
}

