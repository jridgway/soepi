# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110910150651) do

  create_table "pages", :force => true do |t|
    t.string   "title",                                 :null => false
    t.text     "body"
    t.text     "css"
    t.text     "javascript"
    t.string   "browser_title"
    t.string   "custom_title"
    t.boolean  "use_custom_title", :default => false
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.string   "redirect_url"
    t.string   "state",            :default => "draft"
    t.datetime "show_at"
    t.datetime "hide_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.string   "url_regex"
    t.text     "css"
    t.text     "javascript"
    t.datetime "show_at"
    t.datetime "hide_at"
    t.string   "state",      :default => "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.string   "content_type", :default => "Plain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

end
