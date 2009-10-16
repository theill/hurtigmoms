class CreateFiscalYears < ActiveRecord::Migration
  def self.up
    create_table :fiscal_years do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps
    end
    
    add_column :postings, :fiscal_year_id, :integer
    
    User.all.each do |u|
      year = FiscalYear.create(:user_id => u.id, :start_date => Date.new(2009), :end_date => (Date.new(2010) - 1.day), :name => 'År 2009')
      u.postings.update_all("fiscal_year_id = #{year.id}")
    end
  end

  def self.down
    remove_column :postings, :fiscal_year_id
    drop_table :fiscal_years
  end
end
