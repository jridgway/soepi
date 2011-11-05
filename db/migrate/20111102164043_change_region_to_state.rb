class ChangeRegionToState < ActiveRecord::Migration
  def up
    remove_column :members, :region
    add_column :members, :state, :string
    remove_column :targets, :region
    add_column :targets, :state, :string
    remove_column :targets, :location_target_by_address
    add_column :targets, :location_type, :string, :default => 'address'
    create_table "regions_targets", :id => false, :force => true do |t|
      t.integer "target_id"
      t.integer "region_id"
    end
  end

  def down
    remove_column :members, :state
    add_column :members, :region, :string
    remove_column :targets, :state
    add_column :targets, :region, :string
    add_column :targets, :location_target_by_address, :boolean, :default => true
    remove_column :targets, :location_type
    drop_table :regions_targets
  end
end
