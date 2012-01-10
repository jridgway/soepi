class RemoveOldTables < ActiveRecord::Migration
  def up
    drop_table :slides
    drop_table :actions
    drop_table :charts
    drop_table :petitions
    drop_table :petitioners
    drop_table :versions
  end

  def down
    create_table "slides", :force => true do |t|
      t.string   "description"
      t.integer  "position"
      t.datetime "publish_at",    :default => '2011-10-31 20:49:21'
      t.datetime "expires_at"
      t.string   "img"
      t.string   "img_uid"
      t.string   "img_mime_type"
      t.string   "img_name"
      t.integer  "img_size"
      t.integer  "img_width"
      t.integer  "img_height"
      t.string   "img_image_uid"
      t.string   "img_image_ext"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "actions", :force => true do |t|
      t.string   "actionable_type"
      t.integer  "actionable_id"
      t.integer  "member_id"
      t.integer  "times"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "charts", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.integer  "member_id"
      t.boolean  "anonymous"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
    
    create_table "petitioners", :force => true do |t|
      t.integer  "petition_id"
      t.integer  "member_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "petitions", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.text     "promise"
      t.integer  "member_id"
      t.string   "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
    
    create_table "versions", :force => true do |t|
      t.string   "item_type",  :null => false
      t.integer  "item_id",    :null => false
      t.string   "event",      :null => false
      t.string   "whodunnit"
      t.text     "object"
      t.datetime "created_at"
    end
  end
end
