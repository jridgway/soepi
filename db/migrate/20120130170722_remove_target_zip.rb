class RemoveTargetZip < ActiveRecord::Migration
  def up
    remove_column :targets, :postal_code
  end

  def down
    add_column :targets, :postal_code, :string
  end
end
