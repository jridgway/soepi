class RemoveWeightsToSurveys < ActiveRecord::Migration
  def up
    remove_column :surveys, :weights
  end

  def down
    add_column :surveys, :weights, :text
  end
end
