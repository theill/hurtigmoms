require 'net/imap'

class Inbox
  def fetch
    mp = MailParser.new
    
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login('bilag@hurtigmoms.dk', '653976')
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      begin
        # Rails.logger.debug("Looking up message #{message_id}")
        puts "Looking up message #{message_id}"
        msg = imap.fetch(message_id, "RFC822")
        mp.parse(TMail::Mail.parse(msg.first.attr["RFC822"]))
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        puts "failed to process message #{e.message}"
        # Rails.logger.error "[" + Time.now.to_s + "] " + e.message
      end
    end
    imap.expunge
    imap.logout
  end

end