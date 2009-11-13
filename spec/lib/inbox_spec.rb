require File.dirname(__FILE__) + '/../spec_helper'

describe "An inbox instance" do
  before do
    @inbox = Inbox.new
  end

  it("should have a perform method") do
    # required for "DelayedJob"
    @inbox.should respond_to :perform
  end
  
end