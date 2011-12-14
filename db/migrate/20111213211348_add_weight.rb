class AddWeight < ActiveRecord::Migration
  def up
    add_column :participant_surveys, :weight, :float, :default => 1.0
  end

  def down
    remove_column :participant_surveys, :weight
  end
end
