class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :label
      t.integer :position

      t.timestamps
    end
  end
end
