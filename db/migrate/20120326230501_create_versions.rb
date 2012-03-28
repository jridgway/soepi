class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :versionable_id
      t.string :versionable_type
      t.integer :member_id
      t.text :data
      t.boolean :current, :default => false
      t.integer :position

      t.timestamps
    end
  end
end
