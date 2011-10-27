class RemoveNotifiableMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :notifiable_id
    remove_column :messages, :notifiable_type
  end

  def down
    add_column :messages, :notifiable_id, :integer
    add_column :messages, :notifiable_type, :string
  end
end
