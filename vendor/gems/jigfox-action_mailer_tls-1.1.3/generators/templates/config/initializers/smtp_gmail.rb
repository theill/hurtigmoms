# This file is automatically copied into RAILS_ROOT/initializers

require "smtp_tls"

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

unless ENV['GMAIL_USER'] && ENV['GMAIL_PASS']
  config_file = "#{RAILS_ROOT}/config/smtp_gmail.yml"
  raise "Sorry, you must have #{config_file}" unless File.exists?(config_file) || ENV['EMAIL']

  config_options = YAML.load_file(config_file) 
  ActionMailer::Base.smtp_settings.merge(config_options) # Configuration options override default options
else
  ActionMailer::Base.smtp_settings.merge({:user_name => ENV['GMAIL_USER'], :password => ENV['GMAIL_PASS']})
end