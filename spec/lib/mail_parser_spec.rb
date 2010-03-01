require File.dirname(__FILE__) + '/../spec_helper'

describe "A MailParser" do
  it "should correctly parse amount and currency from recognized harvest mail" do
    mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt"))
    
    email, transaction = MailParser.new(mail).parse
    email.should == "john.doe@hurtigmoms.test"
    transaction.note.should == 'Harvest Subscription'
    transaction.amount.should == 12.75
    transaction.currency.should == 'USD'
    transaction.created_at.should == Date.new(2009, 9, 4)
    transaction.annexes.should_not be_nil
    transaction.should have(1).annexes
  end

  it "should remove attachments from mails" do
    mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest_danish.txt"))
    
    original_length = mail.to_s.length
    
    email, transaction = MailParser.new(mail).parse
    email.should == "john.doe@hurtigmoms.test"
    transaction.note.should == 'Faktura #2009020 fra Commanigy'
    transaction.amount.should == 15468.75
    transaction.currency.should == 'DKK'
    transaction.created_at.should == Date.new(2009, 10, 8)
    transaction.annexes.should_not be_nil
    transaction.should have(2).annexes
    transaction.annexes.first.attachment_file_name.should eql("FAKTURA_2009020_Commanigy.pdf")
    transaction.annexes.last.attachment_file_size.should < original_length
  end

end