class CreatePostingImports < ActiveRecord::Migration
  def self.up
    create_table :posting_imports do |t|
      t.integer :user_id, :null => false
      t.text :data, :null => false
      t.string :state, :limit => 1, :default => 'N', :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :posting_imports
  end
end
