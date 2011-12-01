class BootingEc2 < ActiveRecord::Migration
  def up
    add_column :members, :booting_ec2_instance, :boolean, :default => false
    add_column :members, :ec2_last_accessed_at, :datetime
  end

  def down
    remove_column :members, :booting_ec2_instance
    remove_column :members, :ec2_last_accessed_at
  end
end
