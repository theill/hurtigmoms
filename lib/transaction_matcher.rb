class TransactionMatcher

  def initialize(transactions)
    @transactions = transactions
  end
  
  # match a single 'buy' or 'sell' transaction with an array of payment transactions by matching
  # on date, amount and currency
  def match(transaction)
    # ensure we don't already match this up if we have it in our system
    return false if exists?(transaction)
    
    matching_transaction = @transactions.find do |t|
      date = t.created_at.to_date
      amount = t.amount
      currency = t.currency
      
      if t.transaction_type == Transaction::TRANSACTION_TYPES[:pay]
        amount = amount.abs
      end
      
      # do special parsing for "Nordea" statements
      matches = (t.note || '').scan /Visa køb (USD|EUR)\W*(\d+(\,(\d+))?)/
      other_amount = matches[0] ? (matches[0][1].gsub(/,/, '.').to_f) : 0.0
      if other_amount > 0.0
        currency = matches[0][0]
        amount = other_amount
      end
      
      Rails.logger.debug("matching: #{'%10s' % transaction.amount} == #{'%10s' % amount}, #{'%3s' % transaction.currency} == #{'%3s' % currency}, #{'%10s' % transaction.created_at.to_date} == #{date}")
      
      # now do actual match based on parsed values
      (transaction.amount == amount) && (transaction.currency == currency) && ((transaction.created_at.to_date - 3.days)..transaction.created_at.to_date).include?(date)
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
    transaction.attachment_no = matching_transaction.attachment_no unless matching_transaction.attachment_no.blank?
    
    # associate new transaction with existing one
    transaction.equalizations.build(:transaction => transaction, :related_transaction => matching_transaction)
  end
  
end