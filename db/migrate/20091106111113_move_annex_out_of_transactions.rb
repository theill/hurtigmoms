class MoveAnnexOutOfTransactions < ActiveRecord::Migration
  def self.up
    add_column :annexes, :transaction_id, :integer
    remove_column :annexes, :user_id
    
    # reverse connection
    Transaction.all.each do |t|
      Annex.find(t.annex_id).update_attribute(:transaction_id, t.id) if t.annex_id
      
      if t.external_data
        filename = "#{Rails.root}/tmp/#{t.id}_parsed_mail.txt"
        File.open(filename, 'w') do |f|
          f.write(t.external_data)
        end
        
        File.open(filename, 'r') do |f|
          t.annexes.create(:attachment => f)
        end
        
        File.delete(filename)
      end
    end
    
    remove_column :transactions, :annex_id
  end

  def self.down
    add_column :annexes, :user_id, :integer
    add_column :transactions, :annex_id, :integer
    
    Annex.all.each do |a|
      Transaction.find(a.transaction_id).update_attribute(:annex_id, a.id) if a.transaction_id
    end
    
    remove_column :annexes, :transaction_id
  end
end
