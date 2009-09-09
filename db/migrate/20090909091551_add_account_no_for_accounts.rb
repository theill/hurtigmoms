class AddAccountNoForAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :account_no, :string
  end

  def self.down
    remove_column :accounts, :account_no
  end
end
