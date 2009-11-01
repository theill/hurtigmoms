class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :fiscal_year_id, :null => false
      t.integer :transaction_type, :null => false, :default => 1
      t.integer :account_id, :null => false
      t.decimal :amount, :null => false
      t.text :note
      t.integer :attachment_no
      t.integer :attachment_id
      t.text :external_data

      t.timestamps
    end
    
    create_table :attachments, :force => true do |t|
      t.integer :user_id, :null => false
      t.string :data_file_name
      t.string :data_content_type
      t.integer :data_file_size
      
      t.timestamps
    end
    
    # convert all existing postings into transactions and into attachments
  end

  def self.down
    drop_table :attachments
    drop_table :transactions
  end
end