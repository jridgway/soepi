class DropClosing < ActiveRecord::Migration
  def up    
    remove_column :surveys, :minimum_completes_needed
    remove_column :surveys, :maximum_completes_needed
    remove_column :surveys, :closes_soft_at
    remove_column :surveys, :closes_hard_at
  end

  def down
    add_column :surveys, :minimum_completes_needed, :integer
    add_column :surveys, :maximum_completes_needed, :integer
    add_column :surveys, :closes_soft_at, :datetime
    add_column :surveys, :closes_hard_at, :datetime
  end
end
