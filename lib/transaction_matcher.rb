class TransactionMatcher

  def initialize(transactions)
    @transactions = transactions
  end
  
  def match(transaction)
    # ensure we don't already match this up if we have it in our system
    return false if exists?(transaction)
    
    matching_transaction = @transactions.find do |t|
      currency = 'DKK'
      amount = transaction.amount
      date = transaction.created_at.to_date
      
      if t.transaction_type == Transaction::TRANSACTION_TYPES[:pay]
        amount = amount.abs
      end
      
      # do special parsing for "Nordea" statements
      matches = (transaction.note || '').scan /Visa køb (USD|EUR)\W*(\d+(\,(\d+))?)/
      other_amount = matches[0] ? (matches[0][1].gsub(/,/, '.').to_f) : 0.0
      if other_amount > 0.0
        currency = matches[0][0]
        amount = other_amount
      end
      
      # now do actual match based on parsed values
      (t.amount == amount) && (t.currency == currency) && (t.created_at.to_date..(t.created_at.to_date + 3.days)).include?(date)
    end
    
    matching_transaction ? combine(transaction, matching_transaction) : false
  end
  
  private
  
  def exists?(transaction)
    @transactions.any? do |t|
      t.note == transaction.note && t.amount == transaction.amount && t.created_at.to_date == transaction.created_at.to_date && t.currency == transaction.currency
    end
  end
  
  def combine(transaction, matching_transaction)
    # related transactions have same attachment no
    transaction.attachment_no = matching_transaction.attachment_no
    
    # associate new transaction with existing one
    transaction.equalizations.build(:related_transaction => matching_transaction)
  end
  
end