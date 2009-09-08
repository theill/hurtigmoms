require 'net/imap'

class Inbox
  def fetch
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login('bilag@hurtigmoms.dk', '653976')
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      begin
        # Rails.logger.debug("Looking up message #{message_id}")
        puts "Looking up message #{message_id}"
        msg = imap.fetch(message_id, "RFC822")
        parse(msg.first.attr["RFC822"])
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        puts "failed to process message #{e.message}"
        # Rails.logger.error "[" + Time.now.to_s + "] " + e.message
      end
    end
    imap.expunge
    imap.logout
  end
  
  private
  
  def parse(msg)
    mail = TMail::Mail.parse(msg)
    puts "Got mail #{mail.subject} from #{mail.from} #{mail.has_attachments? ? 'with' : 'without'} attachments"
    
    # lookup or create user
    user = User.find_by_email(mail.from) || setup_user(mail.subject)
    
    parsed_attributes = recognize_and_parse_mail(mail)
    
    posting = user.postings.create!(:note => parsed_attributes[:description], :account_id => 1, :amount => parsed_attributes[:amount])
    associate_attachments(posting, mail) if mail.has_attachments?
  end
  
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
  	# support@getharvest.com
  	
    # do Harvest amount parsing
    parsed_amount = (mail.body || "").scan(/amount:\W?(\$)?([\d|\.]*)\W?\(?(DKK|USD|NOK|SEK|EUR)?\)?/i).flatten
    amount = (parsed_amount.length > 1) ? parsed_amount[1] : "0.0"
    
    description = mail.subject.gsub(/^Fwd: /, '')
  	
  	{ :amount => amount, :currency => "USD", :account_type => 'sale', :description => description }
  end
  
end