class FixParticipantSurveys < ActiveRecord::Migration
  def up
    rename_column :participant_surveys, :region, :state
    add_column :participant_surveys, :region_id, :integer
    drop_table :versions
    remove_column :participant_responses, :question_version
    remove_column :participant_surveys, :survey_version
  end

  def down
    rename_column :participant_surveys, :state, :region
    remove_column :participant_surveys, :region_id
    add_column :participant_responses, :question_version, :integer
    add_column :participant_surveys, :survey_version, :integer
    create_table "versions", :force => true do |t|
      t.string   "item_type",  :null => false
      t.integer  "item_id",    :null => false
      t.string   "event",      :null => false
      t.string   "whodunnit"
      t.text     "object"
      t.datetime "created_at"
    end
    add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  end
end
