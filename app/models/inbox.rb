require 'net/imap'

class Inbox
  def perform
    Rails.logger.debug("Checking inbox for new attachments at #{Time.now.utc}")
    
    mp = MailParser.new
    
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login('bilag@hurtigmoms.dk', '653976')
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      begin
        Rails.logger.debug("Processing message #{message_id}")
        # puts "Looking up message #{message_id}"
        msg = imap.fetch(message_id, "RFC822")
        mp.parse(TMail::Mail.parse(msg.first.attr["RFC822"]))
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        # puts "failed to process message #{e.message}"
        Rails.logger.error "Failed to process message #{message_id} at #{Time.now.utc}. Error: #{e.message}"
      end
    end
    imap.expunge
    imap.logout
    
    Delayed::Job.enqueue ::Inbox.new, 0, 1.minute.from_now
  end

end