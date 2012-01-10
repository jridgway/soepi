class MergeScriptsReports < ActiveRecord::Migration
  def up
    drop_table :r_scripts
    drop_table :r_script_inputs
    remove_column :reports, :r_script_id
  end

  def down
    create_table "r_scripts", :force => true do |t|
      t.integer  "member_id",                             :null => false
      t.integer  "forked_from_id"
      t.string   "title",                                 :null => false
      t.text     "description"
      t.text     "code"
      t.string   "state",          :default => "pending"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
    create_table "r_script_inputs", :force => true do |t|
      t.integer  "r_script_id"
      t.string   "name"
      t.text     "description"
      t.integer  "position"
      t.string   "itype"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "survey_id"
      t.string   "default_character"
      t.decimal  "default_numeric"
      t.integer  "question_id"
    end
    add_column :reports, :r_script_id, :integer
  end
end
