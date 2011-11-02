class RemoveOccupation < ActiveRecord::Migration
  def up
    drop_table :occupations
    remove_column :members, :occupation_id
    remove_column :participant_surveys, :occupation_id
    remove_column :targets, :target_by_occupation
    drop_table :occupations_targets
    drop_table :target_occupations
  end

  def down
    create_table "occupations", :force => true do |t|
      t.string   "label"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_column :members, :occupation_id, :integer
    add_column :participant_surveys, :occupation_id, :integer
    add_column :targets, :target_by_occupation, :boolean, :default => false
    create_table "occupations_targets", :id => false, :force => true do |t|
      t.integer "target_id"
      t.integer "occupation_id"
    end
    create_table "target_occupations", :force => true do |t|
      t.integer  "target_id"
      t.integer  "occupation_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
