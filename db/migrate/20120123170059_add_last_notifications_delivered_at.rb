class AddLastNotificationsDeliveredAt < ActiveRecord::Migration
  def change
    add_column :members, :last_notifications_delivered_at, :datetime
  end
end
