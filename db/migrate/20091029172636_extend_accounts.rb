class ExtendAccounts < ActiveRecord::Migration
  def self.up
    change_column :accounts, :name, :string, :null => false
    change_column :accounts, :account_type, :integer, :null => false
    add_column :accounts, :description, :text, :null => true
    add_column :accounts, :aggregate_from_account_no, :integer, :null => true
    rename_column :accounts, :account_no, :old_account_no
    
    add_column :accounts, :account_no, :integer, :null => true
    Account.all.each { |a| a.update_attributes({:account_no => a.old_account_no.to_i, :account_type => Account::ACCOUNT_TYPES[:operating]}) }
    remove_column :accounts, :old_account_no
  end
  
  def self.down
    change_column :accounts, :name, :string, :null => true
    change_column :accounts, :account_type, :integer, :null => true
    remove_column :accounts, :aggregate_from_account_no
    remove_column :accounts, :description
    change_column :accounts, :account_no, :string
  end
end