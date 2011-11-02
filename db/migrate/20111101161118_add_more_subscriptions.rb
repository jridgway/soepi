class AddMoreSubscriptions < ActiveRecord::Migration
  def up
    add_column :members, :subscription_weekly_summaries, :boolean, :default => true
  end

  def down
    remove_column :members, :subscription_weekly_summaries
  end
end
