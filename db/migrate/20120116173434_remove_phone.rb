class RemovePhone < ActiveRecord::Migration
  def up
    remove_column :members, :phone
  end

  def down
    add_column :members, :phone, :string
  end
end
