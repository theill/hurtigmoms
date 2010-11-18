class AddDropboxToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :dropbox, :string
    
    User.all.each do |u|
      u.update_attribute(:cvr, nil) if u.cvr.blank?
      u.update_attribute(:dropbox, u.cvr) if u.cvr
    end
  end

  def self.down
    remove_column :users, :dropbox
  end
end
