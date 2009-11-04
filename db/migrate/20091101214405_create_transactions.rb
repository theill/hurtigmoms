class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :fiscal_year_id, :null => false
      t.integer :transaction_type, :null => false, :default => 1
      t.decimal :amount, :null => false
      t.string :currency, :null => false, :default => 'DKK', :limit => 3
      t.integer :customer_id
      t.text :note
      t.integer :attachment_no, :default => 0
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
      
      if [120, 137, 138].include?(posting.account.account_no)
        transaction_type = Transaction::TRANSACTION_TYPES[:sell]
      else
        transaction_type = Transaction::TRANSACTION_TYPES[:buy]
      end
      
      transaction = posting.fiscal_year.transactions.create(:transaction_type => transaction_type,
        :amount => posting.amount, :currency => posting.currency, :note => posting.note, :attachment_no => posting.attachment_no,
        :external_data => posting.attachment_email, :customer_id => posting.customer_id, :created_at => posting.created_at)
      
      if posting.attachment?
        begin
          annex = user.annexes.create(:attachment => posting.attachment)
          transaction.update_attribute(:annex, annex)
        rescue
          # some attachments might not exist on S3
        end
      end
    end
    
    Posting.delete_all
    
    # currency not needed for postings since everything is calculated in "default currency" (might be set on fiscal year later)
    remove_column :postings, :currency
  end

  def self.down
    add_column :postings, :currency, :string,                             :default => "DKK", :null => false
    drop_table :annexes
    drop_table :transactions
  end
end