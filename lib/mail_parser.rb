# Parses a single mail
class MailParser < TextParser
  FILTERED_MIME_TYPES = ["application/pdf", "image/png", "image/gif", "image/jpeg", "image/pjpeg", "image/bmp", "application/x-compressed", "application/x-zip-compressed", "application/zip", "multipart/x-zip"]
  
  def initialize(mail)
    @mail = mail
  end
  
  def parse
    Rails.logger.debug "Got mail #{@mail.subject} from #{@mail.from} #{@mail.has_attachments? ? 'with' : 'without'} attachments"
    
    parsed_attributes = recognize_and_parse_mail(@mail).merge(:transaction_type => Transaction::TRANSACTION_TYPES[:buy], :attachment_no => 0)
    
    # if @mail.has_attachments? && (parsed_attributes[:amount].blank? || parsed_attributes[:amount] == 0.0)
    #   # TODO: let's parse associated attachments in order to find amount
    #   
    # end
    
    transaction = Transaction.new(parsed_attributes)
    transaction.build_attachments(associate_attachments(@mail))
    
    [@mail.from.to_s, transaction]
  end
  
  private
  
  def associate_attachments(mail)
    attachments = []
    
    if mail.has_attachments?
      mail.attachments.each { |a| attachments << a }
      
      # remove recognized attachments from mail (so we don't need to store base64 encoded version)
      mail.parts.delete_if { |p| FILTERED_MIME_TYPES.include?(p.content_type) }
    end
    
    # add actual mail as an attachment as well
    attachment = TMail::Attachment.new(mail.to_s)
    attachment.original_filename = (mail.subject || 'original-mail').parameterize.to_s[0, 40] + '.txt'
    attachment.content_type = mail.header['content-type']
    attachments << attachment
    
    attachments
  end
  
  def recognize_and_parse_mail(mail)
    amount = 0.0
    date = Time.now.utc.to_datetime
    currency = 'DKK'
    # account_no = nil
    
    # trim forwarding and replying rules from subject
    description = (mail.subject || '').gsub(/^fwd: /i, '').gsub(/^fw: /i, '').gsub(/^re: /i, '').gsub(/^vs: /i, '').gsub(/^sv: /i, '')
    
    # remove additional whitespaces
    description = description.split.join(' ').gsub(/=C2=A0/, ' ')
    
    if (mail.body && mail.body.include?('support@getharvest.com'))
      # do Harvest parsing
      parsed_amount = mail.body.scan(/amount:\W?(\$)?([\d|\.]*)\W?\(?(DKK|USD|GBP|NOK|SEK|EUR)?\)?/i).flatten
      amount = (parsed_amount[1] if parsed_amount.length > 1) || amount
      currency = (parsed_amount[2] if parsed_amount.length > 2) || currency
      
      parsed_date = mail.body.scan(/date:\W?(\d\d \w{3} \w{4})/i).flatten
      date = (parsed_date.length > 0) ? parsed_date[0].to_datetime : Time.now.utc.to_datetime
    elsif (mail.body && mail.body.include?('support@github.com'))
      # do GitHub parsing
      parsed_amount = mail.body.scan(/amount:\W?(DKK|USD|GBP|NOK|SEK|EUR)?\W?\$?([\d|\.]*)/i).flatten
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
      # parsed_amount = mail.body.scan(/amount:\W?\$?([\d|\.]*)\W?(DKK|USD|GBP|NOK|SEK|EUR)?/i).flatten
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
    { :amount => amount.to_f, :currency => currency.upcase, :note => description, :created_at => date }
  end
end