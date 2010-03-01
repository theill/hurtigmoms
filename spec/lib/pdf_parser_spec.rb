require File.dirname(__FILE__) + '/../spec_helper'

describe "A PdfParser" do
  it "should correctly parse amount from github" do
    p = "#{RAILS_ROOT}/test/fixtures/pdf/github.pdf"
    
    o = PdfParser.new(p).parse
    o[:amount].should == 12.00
    o[:currency].should == "USD"
  end

  it "should correctly parse amount from commanigy" do
    p = "#{RAILS_ROOT}/test/fixtures/pdf/commanigy.pdf"
    
    o = PdfParser.new(p).parse
    o[:amount].should == 3750.00
    o[:currency].should == "DKK"
  end

  it "should correctly parse amount from it-kartellet" do
    p = "#{RAILS_ROOT}/test/fixtures/pdf/itkartellet.pdf"
    
    o = PdfParser.new(p).parse
    o[:amount].should == 4325.00
    o[:currency].should == "DKK"
  end

  it "should correctly parse amount from google adwords" do
    p = "#{RAILS_ROOT}/test/fixtures/pdf/google-adwords.pdf"
    
    o = PdfParser.new(p).parse
    o[:amount].should == 31.00
    o[:currency].should == "USD"
  end

  it "should correctly parse amount from copenhouse" do
    p = "#{RAILS_ROOT}/test/fixtures/pdf/copenhouse.pdf"
    
    o = PdfParser.new(p).parse
    o[:amount].should == 6250.00
    o[:currency].should == "DKK"
  end


  # it "should correctly parse amount from gratisdns" do
  #   p = "#{RAILS_ROOT}/test/fixtures/pdf/gratisdns.pdf"
  #   
  #   o = PdfParser.new(p).parse
  #   o[:amount].should == 90.10
  #   o[:currency].should == "DKK"
  # end

  # it "should correctly parse amount from shareit" do
  #   p = "#{RAILS_ROOT}/test/fixtures/pdf/shareit.pdf"
  #   
  #   o = PdfParser.new(p).parse
  #   o[:amount].should == 4325.00
  #   o[:currency].should == "DKK"
  # end

end