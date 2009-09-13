class AddAttachmentEmailToPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :attachment_email, :text
  end

  def self.down
    remove_column :postings, :attachment_email
  end
end
