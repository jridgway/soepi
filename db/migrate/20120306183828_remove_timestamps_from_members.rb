class RemoveTimestampsFromMembers < ActiveRecord::Migration
  def up
    change_column :members, :remember_created_at, :date
    change_column :members, :confirmed_at, :date
    change_column :members, :confirmation_sent_at, :date
    change_column :members, :remember_created_at, :date
    remove_column :member_tokens, :created_at
    remove_column :member_tokens, :updated_at
  end

  def down
    change_column :members, :remember_created_at, :datetime
    change_column :members, :confirmed_at, :datetime
    change_column :members, :confirmation_sent_at, :datetime
    change_column :members, :remember_created_at, :datetime
    add_column :member_tokens, :created_at, :datetime
    add_column :member_tokens, :updated_at, :datetime
  end
end
