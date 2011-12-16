class FixRScriptInputs < ActiveRecord::Migration
  def up
    add_column :r_script_inputs, :survey_id, :integer
    remove_column :r_script_inputs, :default
    add_column :r_script_inputs, :default_character, :string
    add_column :r_script_inputs, :default_numeric, :numeric
  end

  def down
    remove_column :r_script_inputs, :survey_id
    add_column :r_script_inputs, :default, :text
    remove_column :r_script_inputs, :default_character, :string
    remove_column :r_script_inputs, :default_numeric, :numeric
  end
end
