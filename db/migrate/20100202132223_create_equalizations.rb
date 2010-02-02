class CreateEqualizations < ActiveRecord::Migration
  def self.up
    create_table :equalizations do |t|
      t.integer :transaction_id
      t.integer :related_transaction_id
    end
  end

  def self.down
    drop_table :equalizations
  end
end
