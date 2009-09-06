class AddCvrOnUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cvr, :string
  end

  def self.down
    remove_column :users, :cvr
  end
end
