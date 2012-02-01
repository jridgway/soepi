class AddWeightsToSurveys < ActiveRecord::Migration
  def up
    add_column :surveys, :weights, :text
  end

  def down
    remove_column :surveys, :weights
  end
end
