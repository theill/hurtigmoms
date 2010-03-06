class AddGbpExchangeRate < ActiveRecord::Migration
  def self.up
    ExchangeRate.create!(:currency => 'GBP', :rate => 0.12076852)
  end

  def self.down
    ExchangeRate.find_by_currency('GBP').destroy
  end
end
