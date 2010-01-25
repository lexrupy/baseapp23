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

ActiveRecord::Schema.define(:version => 20100115163922) do

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_displays", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_locations", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_manufacturers", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_models", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_operating_systems", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_processors", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_suppliers", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_users", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_videos", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "item_type"
    t.string   "item_role"
    t.string   "user"
    t.string   "item_model"
    t.string   "serial"
    t.string   "manufacturer"
    t.string   "operating_system"
    t.string   "ip_address"
    t.string   "subnet"
    t.string   "dhcp"
    t.integer  "memory"
    t.integer  "disk"
    t.string   "video"
    t.string   "display"
    t.string   "optical_drive"
    t.string   "processor"
    t.string   "status"
    t.string   "location"
    t.string   "supplier"
    t.decimal  "cost"
    t.datetime "guarantee"
    t.string   "document"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "nick_name"
    t.string   "real_name"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify_ticket_update"
  end

  create_table "resource_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "resource"
    t.string   "name"
    t.string   "description"
    t.integer  "resource_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources_roles", :id => false, :force => true do |t|
    t.integer "resource_id"
    t.integer "role_id"
  end

  create_table "resources_users", :id => false, :force => true do |t|
    t.integer "resource_id"
    t.integer "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "label"
    t.string   "identifier"
    t.text     "description"
    t.string   "field_type",     :default => "string"
    t.string   "select_options"
    t.string   "select_titles"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "ticket_updates", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.string   "assigned_change"
    t.string   "status_change"
    t.string   "category_change"
    t.string   "priority_change"
    t.text     "body"
    t.string   "markup_engine",   :default => "markdown"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "assigned_to_id"
    t.string   "subject"
    t.text     "body"
    t.string   "category"
    t.string   "markup_engine",  :default => "markdown"
    t.string   "status",         :default => "new"
    t.string   "priority",       :default => "normal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets_users", :id => false, :force => true do |t|
    t.integer "ticket_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :limit => 100
    t.string   "login",               :limit => 100,                        :null => false
    t.string   "crypted_password",                                          :null => false
    t.string   "password_salt",                                             :null => false
    t.string   "persistence_token",                                         :null => false
    t.string   "perishable_token",                                          :null => false
    t.string   "single_access_token",                                       :null => false
    t.integer  "login_count",                        :default => 0,         :null => false
    t.string   "state",                              :default => "passive", :null => false
    t.string   "current_login_ip",    :limit => 60
    t.string   "last_login_ip",       :limit => 60
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.boolean  "master",                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
