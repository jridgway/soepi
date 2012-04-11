class SurveyTesting < ActiveRecord::Migration
  def up
    add_column :participants, :tester, :boolean, :default => false
    add_column :participants, :piloter, :boolean, :default => false
  end

  def down
    remove_column :participants, :tester
    remove_column :participants, :piloter
  end
end
