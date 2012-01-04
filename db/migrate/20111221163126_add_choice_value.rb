class AddChoiceValue < ActiveRecord::Migration
  def up
    add_column :survey_question_choices, :value, :string
  end

  def down
    remove_column :survey_question_choices, :value
  end
end
