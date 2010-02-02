require File.dirname(__FILE__) + '/../../spec_helper'

describe "An importing model" do
  before do
    # @csv = "Bogført;Tekst;Rentedato;Beløb;Saldo
    # 12-10-2009;Visa køb USD      12,00            IRIDESCO   212-22641               Den 08.10;09-10-2009;-61,42;145288,61
    # 09-10-2009;Bgs DSB Kbh/Aarhus;08-10-2009;-488,00;145350,03
    # 09-10-2009;Bgs DSB Aarhus/Kbh;08-10-2009;-513,00;145838,03
    # "
    
    transactions = File.read("#{RAILS_ROOT}/spec/bank/bank-halfyear.csv")
    
    @importer = PostingImport.new
    @importer.file = transactions
  end
  
  it "should recognize headers if available in first line" do
    @importer.data = "Bogført;Tekst;Rentedato;Beløb;Saldo
12-10-2009;Visa køb USD      12,00            IRIDESCO   212-22641               Den 08.10;09-10-2009;-61,42;145288,61"
    @importer.headers?.should eql(true)
  end
  
  it "should not assume headers if not available in first line" do
    @importer.data = "12-10-2009;Visa køb USD      12,00            IRIDESCO   212-22641               Den 08.10;09-10-2009;-61,42;145288,61"
    @importer.headers?.should eql(false)
  end
  
  it "should recognize semi-colon column separators" do
    @importer.data = "Bogført;Tekst;Rentedato;Beløb;Saldo"
    @importer.column_seperator.should eql(';')
  end
  
  it "should recognize colon column separators" do
    @importer.data = "Bogført,Tekst,Rentedato,Beløb,Saldo"
    @importer.column_seperator.should eql(',')
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