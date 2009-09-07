class SignupMailer < ActionMailer::Base
  default_url_options[:host] = HOST
  
  def created(user, subject)
    from       DO_NOT_REPLY
    recipients user.email
    subject    I18n.t(:created,
                      :scope   => [:mails, :signup],
                      :default => "An account was created for you")
    body      :user => user, :subject => subject
  end
  
end