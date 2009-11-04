class AddNewAccountplan < ActiveRecord::Migration
  def self.up
    # Account.all.each do |account|
    #   account.update_attribute(:name, account.name + ' (gammel)')
    # end
    
    Account.delete_all
    
    # setup new account plans
    User.all.each do |user|
      user.send(:setup_default_accounts)
    end
  end

  def self.down
    
  end
end
