class AddQLabel < ActiveRecord::Migration
  def up
    add_column :survey_questions, :label, :string
  end

  def down
    remove_column :survey_questions, :label
  end
end
