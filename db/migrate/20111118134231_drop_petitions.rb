class DropPetitions < ActiveRecord::Migration
  def up  
    drop_table :petitioners
    drop_table :petitions
  end

  def down
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
  
    add_index "petitions", ["id"], :name => "index_petitions_on_id", :unique => true
    add_index "petitions", ["member_id"], :name => "index_petitions_on_member_id"
    add_index "petitions", ["slug"], :name => "index_petitions_on_slug"
  end
end
