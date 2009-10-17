class CreateFiscalYears < ActiveRecord::Migration
  def self.up
    create_table :fiscal_years do |t|
      t.integer :user_id, :null => false
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.string :name

      t.timestamps
    end
    
    add_column :postings, :fiscal_year_id, :integer
    add_column :users, :active_fiscal_year_id, :integer
    
    current_year = Date.today.year
    User.all.each do |u|
      year = u.fiscal_years.create(:start_date => Date.new(current_year), :end_date => (Date.new(current_year + 1) - 1.day), :name => 'Regnskab ' + current_year.to_s)
      u.active_fiscal_year = year
      u.save
      
      u.postings.update_all("fiscal_year_id = #{year.id}")
    end
    
    change_column :postings, :fiscal_year_id, :integer, :null => false
    remove_column :postings, :user_id
  end

  def self.down
    add_column :postings, :user_id, :integer
    remove_column :users, :active_fiscal_year_id
    remove_column :postings, :fiscal_year_id
    drop_table :fiscal_years
  end
end
