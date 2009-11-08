class CreateExchangeRates < ActiveRecord::Migration
  def self.up
    create_table :exchange_rates do |t|
      t.string :currency, :null => false
      t.decimal :rate, :null => false

      t.timestamps
    end
    
    ExchangeRate.create!(:currency => 'DKK', :rate => 1.0)
    ExchangeRate.create!(:currency => 'USD', :rate => 0.199366)
    ExchangeRate.create!(:currency => 'EUR', :rate => 0.134379887)
  end

  def self.down
    drop_table :exchange_rates
  end
end
