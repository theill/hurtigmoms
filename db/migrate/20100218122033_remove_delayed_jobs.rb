class RemoveDelayedJobs < ActiveRecord::Migration
  def self.up
    drop_table :delayed_jobs
  end

  def self.down
    create_table "delayed_jobs", :force => true do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.text     "locked_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
