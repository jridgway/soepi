class RemoveTimeZone < ActiveRecord::Migration
  def up
    remove_column :members, :timezone
  end

  def down
    add_column :members, :timezone, :string
  end
end
