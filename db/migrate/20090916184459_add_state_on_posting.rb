class AddStateOnPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :state, :string, :limit => 1, :default => 'A', :null => false
  end

  def self.down
    remove_column :postings, :state
  end
end
