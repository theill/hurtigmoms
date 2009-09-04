class AddAttachmentToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :attachment_file_name, :string
    add_column :postings, :attachment_content_type, :string
    add_column :postings, :attachment_file_size, :integer
    add_column :postings, :attachment_no, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :postings, :attachment_no
    remove_column :postings, :attachment_file_name
    remove_column :postings, :attachment_content_type
    remove_column :postings, :attachment_file_size
  end
end
