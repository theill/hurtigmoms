class AddCustomersToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :customer_id, :integer
    change_column :postings, :user_id, :integer, :null => false
    change_column :postings, :account_id, :integer, :null => false
    change_column :postings, :amount, :decimal, :null => false
    change_column :postings, :currency, :string, :length => 3, :null => false
  end

  def self.down
    remove_column :postings, :customer_id
    change_column :postings, :user_id, :integer, :null => true
    change_column :postings, :account_id, :integer, :null => true
    change_column :postings, :amount, :decimal, :null => true
    change_column :postings, :currency, :string, :length => 3, :null => true
  end
end
