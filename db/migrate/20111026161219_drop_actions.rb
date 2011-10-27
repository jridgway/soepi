class DropActions < ActiveRecord::Migration
  def up
    drop_table :actions
  end

  def down
    create_table "actions", :force => true do |t|
      t.string   "actionable_type"
      t.integer  "actionable_id"
      t.integer  "member_id"
      t.integer  "times"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
