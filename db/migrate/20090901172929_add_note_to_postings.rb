class AddNoteToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :note, :text
  end

  def self.down
    remove_column :postings, :note
  end
end
