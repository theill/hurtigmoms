class RemoveNullOnAttachmentNo < ActiveRecord::Migration
  def self.up
    change_column :postings, :attachment_no, :integer, :null => true
  end

  def self.down
    change_column :postings, :attachment_no, :integer, :null => false
  end
end
