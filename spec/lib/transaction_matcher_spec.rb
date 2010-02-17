require File.dirname(__FILE__) + '/../spec_helper'

describe TransactionMatcher do
  before do
    t1 = Transaction.new(:amount => 100, :currency => 'DKK', :created_at => '2010-01-01', :attachment_no => 1, :note => 'Harvest subscription', :transaction_type => Transaction::TRANSACTION_TYPES[:pay])
    t2 = Transaction.new(:amount => 50, :currency => 'DKK', :created_at => '2010-02-01', :attachment_no => 2, :note => 'Køb af frimærker', :transaction_type => Transaction::TRANSACTION_TYPES[:pay])
    t3 = Transaction.new(:amount => 25, :currency => 'DKK', :created_at => '2010-03-01', :attachment_no => 3, :note => 'Køb af kuglepen', :transaction_type => Transaction::TRANSACTION_TYPES[:pay])
    kreditnota = Transaction.new(:transaction_type => Transaction::TRANSACTION_TYPES[:buy], :amount => -120, :currency => 'DKK', :note => 'Kreditnota fra Telia', :attachment_no =>  4, :created_at => '2009-09-03')
    
    @transactions = [t1, t2, t3, kreditnota]
    @matcher = TransactionMatcher.new(@transactions)
  end
  
  it "should match transactions with equal amount, currency and date" do
    hundred = Transaction.new(:amount => 100, :currency => 'DKK', :created_at => '2010-01-01')
    @matcher.match(hundred).should be_true
  end
  
  it "should set attachment_no on matched transactions" do
    hundred = Transaction.new(:amount => 100, :currency => 'DKK', :created_at => '2010-01-01')
    @matcher.match(hundred)
    hundred.attachment_no.should eql(1)
  end
  
  it "should set equalizations on matched transactions" do
    hundred = Transaction.new(:amount => 100, :currency => 'DKK', :created_at => '2010-01-01')
    @matcher.match(hundred)
    hundred.equalizations.should have(1).transactions
  end
  
  it "should not match transactions with different amounts" do
    @matcher.match(Transaction.new(:amount => 101, :currency => 'DKK', :created_at => '2010-01-01')).should_not be_true
  end
end