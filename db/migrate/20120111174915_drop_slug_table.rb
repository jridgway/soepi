class DropSlugTable < ActiveRecord::Migration
  def up
    drop_table :slugs
  end

  def down
    create_table "slugs", :force => true do |t|
      t.string   "name"
      t.integer  "sluggable_id"
      t.integer  "sequence",                     :default => 1, :null => false
      t.string   "sluggable_type", :limit => 40
      t.string   "scope",          :limit => 40
      t.datetime "created_at"
      t.string   "locale"
    end
  
    add_index "slugs", ["locale"], :name => "index_slugs_on_locale"
    add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
    add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"
  end
end
