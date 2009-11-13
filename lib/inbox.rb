require 'net/imap'

class Inbox
  def perform
    Rails.logger.debug("Checking inbox for new messages at #{Time.now.utc}")
    
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login(ActionMailer::Base.smtp_settings[:user_name], ActionMailer::Base.smtp_settings[:password])
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      begin
        Rails.logger.debug("Processing message #{message_id}")
        msg = imap.fetch(message_id, "RFC822")
        mail = TMail::Mail.parse(msg.first.attr["RFC822"])
        MailParser.new(mail).parse
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        Rails.logger.error "Failed to process message #{message_id} at #{Time.now.utc}. Error: #{e.message}"
      end
    end
    imap.expunge
    imap.logout
    
    # recheck inbox in one minute
    Delayed::Job.enqueue(::Inbox.new, 0, 1.minute.from_now)
  end
end