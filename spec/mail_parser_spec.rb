require File.dirname(__FILE__) + '/spec_helper'

describe MailParser do
  before do
    @mail_parser = MailParser.new
  end
  
  it "should parse amount from harvest mail from existing user" do
    # user = mock("User.find_by_email", :null_object => true)
    
    mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt"))
    @mail_parser.parse(mail)
    
    # @mail_parser.should have(:user).email = "john.doe@local.test"
  end
end