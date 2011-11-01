class RemoveSomeSettings < ActiveRecord::Migration
  def up
    rename_column :members, :subscription_surveys, :subscription_notifications
    remove_column :members, :subscription_petitions
    remove_column :members, :subscription_groups
  end

  def down
    rename_column :members, :subscription_notifications, :subscription_surveys
    add_column :members, :subscription_petitions, :boolean, :default => true
    add_column :members, :subscription_groups, :boolean, :default => true
  end
end
