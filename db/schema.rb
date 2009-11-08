# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091108023353) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",                                       :null => false
    t.integer  "account_type",                               :null => false
    t.integer  "vat_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "aggregate_from_account_no"
    t.decimal  "amount",                    :default => 0.0, :null => false
    t.integer  "account_no"
  end

  create_table "annexes", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
  end

  create_table "customers", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "exchange_rates", :force => true do |t|
    t.string   "currency",   :null => false
    t.decimal  "rate",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fiscal_years", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.date     "start_date", :null => false
    t.date     "end_date",   :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posting_imports", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.text     "data",                                     :null => false
    t.string   "state",      :limit => 1, :default => "N", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postings", :force => true do |t|
    t.integer  "account_id",                                            :null => false
    t.decimal  "amount",                                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.integer  "attachment_no",                        :default => 0
    t.text     "attachment_email"
    t.string   "state",                   :limit => 1, :default => "A", :null => false
    t.integer  "customer_id"
    t.integer  "fiscal_year_id",                                        :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "fiscal_year_id",                                   :null => false
    t.integer  "transaction_type",              :default => 1,     :null => false
    t.decimal  "amount",                                           :null => false
    t.string   "currency",         :limit => 3, :default => "DKK", :null => false
    t.integer  "customer_id"
    t.text     "note"
    t.integer  "attachment_no",                 :default => 0
    t.text     "external_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",    :limit => 128
    t.string   "salt",                  :limit => 128
    t.string   "confirmation_token",    :limit => 128
    t.string   "remember_token",        :limit => 128
    t.boolean  "email_confirmed",                      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company"
    t.string   "cvr"
    t.integer  "active_fiscal_year_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
