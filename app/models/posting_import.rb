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
    
    default_account_in = self.user.accounts.find_by_account_no_and_account_type('0120', Account::ACCOUNT_TYPES[:sell]).id
    default_account_out = self.user.accounts.find_by_account_no_and_account_type('1300', Account::ACCOUNT_TYPES[:buy]).id
    
    # read [date, note, amount] for all postings so we are able to check existing ones
    existing_postings = self.user.active_fiscal_year.postings.find(:all, :select => 'created_at, note, amount')
    
    success_count = duplicate_count = failed_count = 0

    self.parse.each do |row|
      p = self.user.active_fiscal_year.postings.new(:state => Posting::STATES[:imported], :attachment_no => nil)
      self.mapping.each do |column, method|
        next if method.blank?
        
        Rails.logger.debug("trying to set #{row[column.to_i]} into #{method}")
        p.send(method + '=', row[column.to_i])
      end
      
      next if p.amount.nil? || p.created_at.nil?
      
      p.account_id = (p.amount > 0) ? default_account_in : default_account_out
      p.amount = p.amount.abs
      
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
