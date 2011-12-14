class CreateRScriptInputs < ActiveRecord::Migration
  def change
    create_table :r_script_inputs do |t|
      t.integer :r_script_id
      t.string :name
      t.text :description
      t.text :default
      t.integer :position
      t.string :itype

      t.timestamps
    end
  end
end
