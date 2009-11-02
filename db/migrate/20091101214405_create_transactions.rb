class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :fiscal_year_id, :null => false
      t.integer :transaction_type, :null => false, :default => 1
      t.integer :account_id, :null => false
      t.decimal :amount, :null => false
      t.string :currency, :null => false, :default => 'DKK', :limit => 3
      t.text :note
      t.integer :attachment_no
      t.integer :annex_id
      t.text :external_data

      t.timestamps
    end
    
    create_table :annexes do |t|
      t.integer :user_id, :null => false
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      
      t.timestamps
    end
    
    # convert all existing postings into transactions and into attachments
    Posting.all.each do |posting|
      user = posting.fiscal_year.user
      
      if posting.account.account_type == 1
        transaction_type = Transaction::TRANSACTION_TYPES[:sell]
      else
        transaction_type = Transaction::TRANSACTION_TYPES[:buy]
      end
      
      transaction = posting.fiscal_year.transactions.create(:transaction_type => transaction_type, :account_id => posting.account_id, 
        :amount => posting.amount, :currency => posting.currency, :note => posting.note, :attachment_no => posting.attachment_no,
        :external_data => posting.attachment_email)
      
      if posting.attachment?
        annex = transaction.create_annex(:user => user)
        begin
          annex.attachment = posting.attachment
          annex.save
        rescue
          Rails.logger.debug("ups, der skete noget med posting id #{posting.id}")
        end
        transaction.save
      end
    end
    
  end

  def self.down
    drop_table :annexes
    drop_table :transactions
  end
end