class PostingImport < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id
  validates_presence_of :data
  
  attr_accessor :mapping
  
  def file
    ""
  end
  
  def file=(v)
    content = IO.read(v.path)
    self.data = Iconv.iconv('utf-8', 'iso8859-1', content).join('\n')
  end
  
  def import
    # import actual content as Posting records
    
    default_account_in = self.user.accounts.find_by_account_no('1020').id
    default_account_out = self.user.accounts.find_by_account_no('1300').id
    
    # read [date, note, amount] for all postings so we are able to check existing ones
    existing_postings = self.user.active_fiscal_year.postings.find(:all, :include => :account, :select => 'postings.created_at, postings.note, postings.amount, postings.currency, accounts.account_type')
    
    success_count = duplicate_count = failed_count = 0

    self.parse.each do |row|
      p = self.user.active_fiscal_year.postings.new(:state => Posting::STATES[:imported], :attachment_no => nil, :account_id => 0)
      self.mapping.each do |column, method|
        next if method.blank?
        
        parsed_value = row[column.to_i]
        
        # special handling for amount to support danish "100,00" instead of english "100.00"
        if self.user.default_currency == 'DKK' && method == 'amount'
          matches = parsed_value.scan /(\-?\d+(\,(\d+))?)/
          parsed_value = matches[0] ? (matches[0][0].gsub(/,/, '.').to_f) : 0.0
        end
        
        # Rails.logger.debug("trying to set #{parsed_value} into #{method}")
        p.send(method + '=', parsed_value)
      end
      
      next if p.amount.nil? || p.created_at.nil?

      Rails.logger.debug("COMPARE #{p.amount}, #{p.note} with:")

      # match with any existing postings
      match = existing_postings.find do |posting|
        # Rails.logger.debug(" #{posting.amount}, #{posting.note}")
        
        detected_currency = 'DKK'
        amount = p.amount
        
        if posting.account.account_type == Account::ACCOUNT_TYPES[:expense]
          amount = -1.0 * amount
        end
        
        if self.user.default_currency == 'DKK'
          # do special parsing for "Nordea" statements
          matches = (p.note || '').scan /Visa køb (USD|EUR)\W*(\d+(\,(\d+))?)/
          other_amount = matches[0] ? (matches[0][1].gsub(/,/, '.').to_f) : 0.0
          if other_amount > 0.0
            detected_currency = matches[0][0]
            amount = other_amount
          end
        end
        
        (posting.amount == amount) && (posting.currency == detected_currency) && (posting.created_at.to_date..(posting.created_at.to_date + 3.days)).include?(p.created_at.to_date)
      end

      if match
        Rails.logger.debug("**** GOT MATCH for #{match.note} => #{p.note} (amount: #{match.amount})")
        p.attachment_no = match.attachment_no
        p.account_id = match.account_id
      end
      
      p.account_id = (p.amount > 0) ? default_account_in : default_account_out if p.account_id == 0
      # p.amount = p.amount.abs
      
      # ensure we don't already have this in our system
      found = existing_postings.find do |posting|
        posting.note == p.note && posting.amount == p.amount && posting.created_at.to_date == p.created_at.to_date
      end
      
      if found
        duplicate_count += 1
        next
      end
      
      # seems correct so let's insert it
      if p.save
        success_count += 1
      else
        Rails.logger.debug("*** GOT ERROR: #{p.errors.first}")
        failed_count += 1
      end
    end
    
    [success_count, duplicate_count, failed_count]
  end
  
  def parse
    # TODO: guess 'col_sep' and 'headers' by looking at rows and detecting if it
    # contains a ',' or ';' and by checking if any rows are parsable as date. if none
    # in the first row can't be parsed as a date it is probably a header
    FasterCSV.parse(self.data, {:col_sep => ';', :skip_blanks => true, :headers => true})
  end
  
end
