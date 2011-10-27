class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notifiable_id
      t.string :notifiable_type
      t.string :message
      t.integer :member_id
      t.boolean :seen, :default => false

      t.timestamps
    end
  end
end
