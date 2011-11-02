class AddCompletes < ActiveRecord::Migration
  def up
    add_column :participant_surveys, :complete, :boolean, :default => false
  end

  def down
    remove_column :participant_surveys, :complete
  end
end
