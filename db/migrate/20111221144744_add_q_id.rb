class AddQId < ActiveRecord::Migration
  def up
    add_column :survey_downloads, :question_id, :integer
    add_column :r_script_inputs, :question_id, :integer
  end

  def down
    remove_column :survey_downloads, :question_id
    remove_column :r_script_inputs, :question_id
  end
end
