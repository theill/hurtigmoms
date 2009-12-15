require File.dirname(__FILE__) + '/../../spec_helper'

describe "An importing model" do
  before do
    @csv = "Bogført;Tekst;Rentedato;Beløb;Saldo
    12-10-2009;Visa køb USD      12,00            IRIDESCO   212-22641               Den 08.10;09-10-2009;-61,42;145288,61
    09-10-2009;Bgs DSB Kbh/Aarhus;08-10-2009;-488,00;145350,03
    09-10-2009;Bgs DSB Aarhus/Kbh;08-10-2009;-513,00;145838,03
    "
    
  end
  
  it "should recognize headers if available in first line" do
    
  end
  
  it "should recognize semi-colon column separators" do
    
  end

  it "should recognize colon column separators" do
    
  end
  
  it "should import all entries in file" do
    
  end
  
  it "should filter existing transactions" do
    
  end
  
  it "should fail if file isn't CSV formatted" do
    
  end
  
  it "should relate similar transactions" do
    
  end  
end