class MailParser
  def parse(mail)
    Rails.logger.debug "Got mail #{mail.subject} from #{mail.from} #{mail.has_attachments? ? 'with' : 'without'} attachments"
    
    # lookup or create user
    user = User.find_by_email(mail.from) || setup_user(mail)
    
    parsed_attributes = recognize_and_parse_mail(mail)
    
    # only supporting 'buying' at the moment
    account = user.accounts.find_by_account_no_and_account_type('1308', Account::ACCOUNT_TYPES[:buying])
    parsed_attributes.merge!(:account_id => account.id, :attachment_email => mail.to_s)
    
    posting = user.postings.create! parsed_attributes
    associate_attachments(posting, mail) if mail.has_attachments?
  end
  
  private
  
  def setup_user(mail)
    Rails.logger.debug "User with email #{mail.from} not found so will be created"
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
    currency = 'DKK'
    
    # trim forwarding and replying rules from subject
    description = (mail.subject || '').gsub(/^Fwd: /i, '').gsub(/^Fw: /i, '').gsub(/^Re: /i, '').gsub(/^VS: /i, '').gsub(/^SV: /i, '')
    
    # remove additional whitespaces
    description = description.split.join(' ')
    
    if (mail.body && mail.body.include?('support@getharvest.com'))
      # do Harvest parsing
      parsed_amount = mail.body.scan(/amount:\W?(\$)?([\d|\.]*)\W?\(?(DKK|USD|NOK|SEK|EUR)?\)?/i).flatten
      amount = (parsed_amount[1] if parsed_amount.length > 1) || amount
      currency = (parsed_amount[2] if parsed_amount.length > 2) || currency
      
      parsed_date = mail.body.scan(/date:\W?(\d\d \w{3} \w{4})/i).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    elsif (mail.body && mail.body.include?('support@github.com'))
      # do GitHub parsing
      parsed_amount = mail.body.scan(/amount:\W?(DKK|USD|NOK|SEK|EUR)?\W?\$?([\d|\.]*)/i).flatten
      amount = (parsed_amount[1] if parsed_amount.length > 1) || amount
      currency = (parsed_amount[0] if parsed_amount.length > 0) || currency
      
      parsed_date = mail.body.scan(/GITHUB RECEIPT - (\d\d? \w{3} \w{4})/i).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    elsif (mail.body && mail.body.include?('info@campaignmonitor.com'))
      # do Campaign Monitor parsing
      
      # further process caption by removing start of subject
      description = description.gsub(/^Campaign Monitor: Invoice for /, '')
      
      # then capitalize first word
      description = description.sub(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
      
      # get amount (always USD)
      parsed_amount = mail.body.scan(/were charged a total of \*?\s+\$(\d{1,}\.\d{1,})\*?\.?/im).flatten
      amount = (parsed_amount[0] if parsed_amount.length > 0) || amount
      currency = 'USD'
      
      # get date (of order)
      parsed_date = mail.body.scan(/Order Date\s*(\d{1,} \w{3} \d{4})/).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    else
      parsed_amount = mail.body.scan(/amount:\W?\$?([\d|\.]*)\W?(DKK|USD|NOK|SEK|EUR)?/i).flatten
      amount = (parsed_amount[0] if parsed_amount.length > 0) || amount
      currency = (parsed_amount[1] if parsed_amount.length > 1) || currency
      
      parsed_date = mail.body.scan(/date:\W?(\d{4}-\d{2}-\d{2})/i).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    end
        
    { :amount => amount, :currency => currency, :note => description, :created_at => date }
  end
end