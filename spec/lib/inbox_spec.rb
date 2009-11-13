require File.dirname(__FILE__) + '/../spec_helper'

describe "An inbox instance" do
  before do
    @mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt"))
    
    @inbox = Inbox.new
    @inbox.stub!(:connect_and_parse_all_messages).and_return(nil)
    Delayed::Job.delete_all
  end
  
  # required for "DelayedJob" to function
  it("should have a perform method") { @inbox.should respond_to :perform }
  
  it "should setup hash with found email only once" do
    @inbox.send(:parse, @mail)
    @inbox.send(:parse, @mail)
    @inbox.send(:parse, @mail)
    @inbox.messages.length.should eql(1)
    @inbox.messages[@mail.from.to_s].length.should eql(3)
  end
  
  it "should setup two hashes for different emails" do
    @mail.from = ['john.doe.junior@hurtigmoms.test']
    @inbox.send(:parse, @mail)
    @mail.from = ['john.doe.senior@hurtigmoms.test']
    @inbox.send(:parse, @mail)
    
    @inbox.messages.length.should eql(2)
    @inbox.messages['john.doe.junior@hurtigmoms.test'].length.should eql(1)
    @inbox.messages['john.doe.senior@hurtigmoms.test'].length.should eql(1)
  end
  
  it "should create non-existing users" do
    @mail.from = ['john.doe.junior@hurtigmoms.test']
    @inbox.send(:parse, @mail)
    # @inbox.perform
    
    # figure out how to stub paperclip
    # User.find_by_email(@mail.from.to_s).should_not be_nil
  end
  
  it "should setup a DelayedJob when calling perform" do
    @inbox.perform
    Delayed::Job.count(:all).should eql(1)
    # Delayed::Job.find(:first).run_at be_close(2, 0.5)
  end
  
end