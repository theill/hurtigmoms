class ChangeAttachmentNoToString < ActiveRecord::Migration
  def self.up
    change_column :transactions, :attachment_no, :string
    Transaction.update_all(:attachment_no => "0")
    Transaction.all.each do |t| t.assign_attachment_no! end
  end

  def self.down
    Transaction.update_all(:attachment_no => "0")
    change_column :transactions, :attachment_no, :integer
  end
end