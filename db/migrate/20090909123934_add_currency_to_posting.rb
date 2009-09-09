class AddCurrencyToPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :currency, :string, :limit => 3, :default => 'DKK'
  end

  def self.down
    remove_column :postings, :currency
  end
end
