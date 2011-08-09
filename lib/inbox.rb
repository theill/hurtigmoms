require 'net/imap'

class Inbox
  attr_accessor :messages
  
  def initialize
    self.messages = {}
  end
  
  def perform
    Rails.logger.info("Checking inbox for new messages at #{Time.now.utc}")
    
    begin
      connect_and_parse_all_messages
      associate_users_with_transactions
    rescue Net::IMAP::NoResponseError => x
      Rails.logger.error("Unable to get a response from mail server. #{x}")
    end
    
    # # recheck inbox in one minute
    # Delayed::Job.enqueue(::Inbox.new, 0, 1.minute.from_now)
  end
  
  private
  
  def connect_and_parse_all_messages
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login(ActionMailer::Base.smtp_settings[:user_name], ActionMailer::Base.smtp_settings[:password])
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      begin
        Rails.logger.info("Processing message #{message_id}")
        msg = imap.fetch(message_id, "RFC822")
        parse(TMail::Mail.parse(msg.first.attr["RFC822"]))
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        Rails.logger.error("Failed to process message #{message_id} at #{Time.now.utc}. Error: #{e.message}")
      end
    end
    imap.expunge
    imap.logout
  rescue OpenSSL::SSL::SSLError => e
    Rails.logger.error("Unable to connect to Google Mail account caused by SSL error: #{e}")
  end
  
  def parse(mail)
    email, dropbox, transaction = MailParser.new(mail).parse
    
    # lookup users email based on dropbox and use that instead if available
    dropbox_identifier = dropbox.match(/bilag[-\+]([^@]*)@hurtigmoms\.dk/i)
    if dropbox_identifier.present? && dropbox_identifier.length == 2
      dropbox_user = User.find_by_dropbox(dropbox_identifier[1].to_s)
      email = dropbox_user.email if dropbox_user
    end
    
    if self.messages.include?(email)
      self.messages[email] << transaction
    else
      self.messages.merge!({email => [transaction]})
    end
  end
  
  def associate_users_with_transactions
    self.messages.each do |email, transactions|
      user = User.find_by_email(email) || setup_user(email, transactions[0].note)
      
      matcher = TransactionMatcher.new(user.active_fiscal_year.transactions.payments.all)
      transactions.each do |transaction|
        transaction.fiscal_year = user.active_fiscal_year
        matcher.match(transaction)
        Rails.logger.info("We have a transaction: #{transaction.inspect}")
        transaction.set_attachment_no
        Rails.logger.info("after setting attachment no we have: #{transaction.inspect}")
        unless transaction.save
          Rails.logger.error "Not able to save transaction #{transaction.inspect}: #{transaction.errors.inspect}"
        end
      end
    end
  end
  
  def setup_user(email, subject)
    Rails.logger.info "User with email #{email} not found so will be created"
    pwd = generate_password
    user = ::User.new(:email => email, :password => pwd, :password_confirmation => pwd, :company => 'Mit firmanavn')
    ::SignupMailer.deliver_created(user, pwd, subject) if user.save
    user
  end
  
  def generate_password(length=6)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    password = ''
    length.times { |i| password << chars[rand(chars.length)] }
    password
  end
end