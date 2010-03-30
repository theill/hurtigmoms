class AddActiveToExchangeRate < ActiveRecord::Migration
  def self.up
    add_column :exchange_rates, :active, :bool, :default => false
  end

  def self.down
    remove_column :exchange_rates, :active
  end
end
