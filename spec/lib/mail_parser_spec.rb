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
end