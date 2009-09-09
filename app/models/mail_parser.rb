class MailParser
  def parse(mail)
    puts "Got mail #{mail.subject} from #{mail.from} #{mail.has_attachments? ? 'with' : 'without'} attachments"
    
    # lookup or create user
    user = User.find_by_email(mail.from) || setup_user(mail)
    
    parsed_attributes = recognize_and_parse_mail(mail)
    
    account = user.accounts.find_by_account_no_and_account_type('1308', parsed_attributes[:account_type])
    
    posting = user.postings.create! :note => parsed_attributes[:description],
      :account_id => account,
      :amount => parsed_attributes[:amount],
      :created_at => parsed_attributes[:created_at]
    associate_attachments(posting, mail) if mail.has_attachments?
  end
  
  private
  
  def setup_user(mail)
    puts "User with email #{mail.from} not found so will be created"
    user = ::User.new(:email => mail.from, :password => '123456', :password_confirmation => '123456', :company => 'My Company')
    ::SignupMailer.deliver_created(user, mail.subject) if user.save
    user
  end
  
  def associate_attachments(posting, mail)
    mail.attachments.each do |attachment|
      posting.update_attribute(:attachment, attachment)
    end
  end
  
  def recognize_and_parse_mail(mail)
    amount = 0.0
    date = Time.now.utc.to_datetime
    currency = 'USD'
    
    if (mail.body && mail.body.include?('support@getharvest.com'))
      # do Harvest amount parsing
      parsed_amount = mail.body.scan(/amount:\W?(\$)?([\d|\.]*)\W?\(?(DKK|USD|NOK|SEK|EUR)?\)?/i).flatten
      amount = (parsed_amount.length > 1) ? parsed_amount[1] : "0.0"
      
      currency = parsed_amount[2] if (parsed_amount.length > 2)
      
      parsed_date = mail.body.scan(/date:\W?(\d\d \w{3} \w{4})/i).flatten
      puts parsed_date
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
      puts date
    end
    
    description = mail.subject.gsub(/^Fwd: /, '')
    
    { :amount => amount, :currency => currency, :account_type => Account::ACCOUNT_TYPES[:buying], :description => description, :created_at => date }
  end
end