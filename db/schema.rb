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

ActiveRecord::Schema.define(:version => 20091021110030) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "locations", :force => true do |t|
    t.string   "locatable_type"
    t.integer  "locatable_id"
    t.float    "lat"
    t.float    "lng"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "address_line"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posting_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posting_types", ["name"], :name => "index_posting_types_on_name"

  create_table "postings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "posting_type_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "cached_slug"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["authorizable_type", "authorizable_id"], :name => "index_roles_on_authorizable_type_and_authorizable_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "user_emails", :force => true do |t|
    t.integer  "user_id",                                :null => false
    t.string   "new_email",               :limit => 100, :null => false
    t.string   "old_email",               :limit => 100, :null => false
    t.string   "request_code",                           :null => false
    t.datetime "request_expiration_date",                :null => false
    t.datetime "confirmed_at"
    t.string   "status",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_emails", ["request_code"], :name => "index_user_emails_on_request_code"
  add_index "user_emails", ["request_expiration_date"], :name => "index_user_emails_on_request_expiration_date"
  add_index "user_emails", ["user_id"], :name => "index_user_emails_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "email",             :default => "",    :null => false
    t.boolean  "active",            :default => false, :null => false
    t.integer  "login_count",       :default => 0,     :null => false
    t.string   "perishable_token",  :default => "",    :null => false
    t.string   "persistence_token",                    :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
