class CreateRScripts < ActiveRecord::Migration
  def change
    create_table :r_scripts do |t|
      t.integer :member_id, :null => false
      t.integer :forked_from_id
      t.string :title, :null => false
      t.text :description
      t.text :code, :null => false
      t.string :state, :default => 'pending'

      t.timestamps
    end
  end
end
