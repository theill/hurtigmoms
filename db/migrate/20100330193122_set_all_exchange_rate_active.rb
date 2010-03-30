class SetAllExchangeRateActive < ActiveRecord::Migration
  def self.up
    ExchangeRate.update_all(['active = ?', true])
  end

  def self.down
    ExchangeRate.update_all(['active = ?', false])
  end
end
