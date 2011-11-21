class DropTrash < ActiveRecord::Migration
  def up
    drop_table :member_ethnicities
    drop_table :member_races
  end

  def down  
    create_table "member_ethnicities", :force => true do |t|
      t.integer  "member_id"
      t.integer  "ethnicity_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "member_races", :force => true do |t|
      t.integer  "member_id"
      t.integer  "race_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
