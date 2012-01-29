class AddRequireAllSurveys < ActiveRecord::Migration
  def up
    add_column :targets, :require_all_surveys, :boolean, :default => true
  end

  def down
    remove_column :targets, :require_all_surveys
  end
end
