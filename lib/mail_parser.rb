class MailParser
  def parse(mail)
    Rails.logger.debug "Got mail #{mail.subject} from #{mail.from} #{mail.has_attachments? ? 'with' : 'without'} attachments"
    
    # lookup or create user
    user = User.find_by_email(mail.from) || setup_user(mail)
    
    parsed_attributes = recognize_and_parse_mail(mail).merge(:transaction_type => Transaction::TRANSACTION_TYPES[:buy],
      :external_data => mail.to_s,
      :attachment_no => 0)
    
    transaction = user.active_fiscal_year.transactions.create! parsed_attributes
    associate_attachments(transaction, mail) if mail.has_attachments?
    
    a = Tempfile.new('mail')
    a.write(mail.to_s)
    a.rewind
    transaction.annexes.create(:attachment => a)
    a.close
  end
  
  private
  
  def setup_user(mail)
    Rails.logger.debug "User with email #{mail.from} not found so will be created"
    pwd = generate_password
    user = ::User.new(:email => mail.from.to_s, :password => pwd, :password_confirmation => pwd, :company => 'Mit firmanavn')
    ::SignupMailer.deliver_created(user, pwd, mail.subject) if user.save
    user
  end
  
  def generate_password(length=6)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
    password = ''
    length.times { |i| password << chars[rand(chars.length)] }
    password
  end
  
  def associate_attachments(transaction, mail)
    mail.attachments.each do |attachment|
      # annex = transaction.create_annex(:user => transaction.fiscal_year.user)
      # annex.attachment = attachment
      # annex.save!
      # transaction.save
      transaction.annexes.create(:attachment => attachment)
    end
  end
  
  def recognize_and_parse_mail(mail)
    amount = 0.0
    date = Time.now.utc.to_datetime
    currency = 'DKK'
    # account_no = nil
    
    # trim forwarding and replying rules from subject
    description = (mail.subject || '').gsub(/^Fwd: /i, '').gsub(/^Fw: /i, '').gsub(/^Re: /i, '').gsub(/^VS: /i, '').gsub(/^SV: /i, '')
    
    # remove additional whitespaces
    description = description.split.join(' ').gsub(/=C2=A0/, ' ')
    
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
    elsif (mail.body && mail.body.include?('no-reply@spotify.com'))
      # do Spotify parsing
      
      # what kind of item did we buy?
      description = mail.body.gsub(/=C2=A0/, ' ').scan(/^Items bought:\s*(.*)/).flatten.to_s
      
      # get amount (only support kr)
      parsed_amount = mail.body.gsub(/=C2=A0/, ' ').scan(/^Total:[^\d]*(\d*[,\.]\d*)\s*kr/i).flatten
      amount = (parsed_amount[0].gsub(/,/, '.') if parsed_amount.length > 0) || amount
      currency = 'DKK'
      
      parsed_date = mail.body.gsub(/=C2=A0/, ' ').scan(/^Date:.*(\d{4}-\d{2}-\d{2})/).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    elsif (mail.body && mail.body.include?('billing@37signals.com'))
      # do Basecamp parsing
      
      description = mail.body.scan(/Price[\n]-*.*([^\$]*)/i).flatten.to_s.gsub(/-/, '').gsub(/>/, '').squish
      
      parsed_amount = mail.body.scan(/Amount PAID:\s*\$(\d{1,}\.\d{1,})/i).flatten
      amount = (parsed_amount[0] if parsed_amount.length > 0) || amount
      currency = 'USD'
      
      parsed_date = mail.body.scan(/INVOICE.*(\d{4}-\d{2}-\d{2})/im).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    else
      # parsed_amount = mail.body.scan(/amount:\W?\$?([\d|\.]*)\W?(DKK|USD|NOK|SEK|EUR)?/i).flatten
      # amount = (parsed_amount[0] if parsed_amount.length > 0) || amount
      # currency = (parsed_amount[1] if parsed_amount.length > 1) || currency
      
      ga, gc = guess_amount(mail.body)
      amount = ga || amount
      currency = gc || currency
      
      date = guess_date(mail.body) || Time.now.utc.to_datetime
    end
    
    # if (amount.blank? || amount.to_f == 0.0 || currency.blank? || date.blank?)
    #   account_no = 9
    # end
    
    # { :amount => amount, :currency => currency, :note => description, :created_at => date, :account_no => account_no }
    { :amount => amount, :currency => currency.upcase, :note => description, :created_at => date }
  end
  
  def guess_date(body)
    t = body.scan(/date:\W?(\d{4}-\d{2}-\d{2})/i).flatten
    if (t.length > 0)
      date = t[0].to_datetime rescue nil
    end
    return date unless date.nil?
    
    t = body.scan(/date:\W?(.*)/i).flatten
    if (t.length > 0)
      date = t[0].to_datetime rescue nil
    end
    return date unless date.nil?
    
    nil
  end
  
  def guess_amount(body)
    parsed_amount = body.scan(/amount:\W?\$?([\d|\.|\,]*)\W?(DKK|USD|NOK|SEK|EUR)?/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    currency = (parsed_amount[1] if parsed_amount.length > 1)
    return [amount, currency] if amount #&& currency

    parsed_amount = body.scan(/total:\W?\$?([\d|\.|\,]*)\W?(DKK|USD|NOK|SEK|EUR)?/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    currency = (parsed_amount[1] if parsed_amount.length > 1)
    return [amount, currency] if amount && currency
    
    parsed_amount = body.scan(/total:\W?(\$)?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    currency = 'USD' if currency == "$"
    return [amount, currency] if amount && currency

    parsed_amount = body.scan(/beløb:\W?(kr\.)\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    if (currency == 'kr.')
      currency = 'DKK'
      # replace "15.498,75" with "15498.75"
      amount = amount.gsub(/\./, '')
      amount = amount.gsub(/\,/, '.')
    end
    return [amount, currency] if amount && currency
    
    [nil, nil]
  end
end