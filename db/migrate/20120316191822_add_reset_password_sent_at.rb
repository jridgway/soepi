class AddResetPasswordSentAt < ActiveRecord::Migration
  def up
    add_column :members, :reset_password_sent_at, :datetime
  end

  def down
    remove_column :members, :reset_password_sent_at
  end
end
