class AddInitialDepositsForFiscalYears < ActiveRecord::Migration
  def self.up
    add_column :fiscal_years, :initial_deposits, :decimal
  end

  def self.down
    remove_column :fiscal_years, :initial_deposits
  end
end
