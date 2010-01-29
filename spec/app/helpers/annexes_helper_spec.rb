require File.dirname(__FILE__) + '/../../spec_helper'
include AnnexesHelper

describe "AnnexesHelper" do
  before do
    @annex = Annex.new
  end
  
  it "should display mail as plain text" do
    # html = format_as_plain_text(@annex)
    # html.should eql("<>")
  end
end