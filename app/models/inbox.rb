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
        # imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => e
        puts "upsi #{e.message}"
        # Rails.logger.error "[" + Time.now.to_s + "] " + e.message
      end
    end
    imap.expunge
    imap.logout
  end
  
  private
  
  def parse(msg)
    mail = TMail::Mail.parse(msg)
    puts "Got mail #{mail.subject} with attachments? #{mail.has_attachments?}"
    
    user = User.find_by_email(mail.from)
    if user
      posting = user.postings.create(:note => mail.subject)
      if mail.has_attachments?
        mail.attachments.each do |attachment|
          posting.update_attribute(:attachment, attachment)
        end
      end
    else
      puts "User with email #{mail.from} not found"
    end
    
    # mail.from
    # mail.subject
    # if mail.has_attachments?
    #   mail.attachments.each do |attachment|
    #     serving.update_attribute(:photo, attachment)
    #   end
    # end
  end
  
end