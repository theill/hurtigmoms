class SignupMailer < ActionMailer::Base
  default_url_options[:host] = HOST
  
  def created(user, password, original_subject)
    from       DO_NOT_REPLY
    recipients user.email
    subject    I18n.t(:created,
                      :scope   => [:mails, :signup],
                      :default => "An account was created for you")
    body      :user => user, :password => password, :original_subject => original_subject
  end
  
end