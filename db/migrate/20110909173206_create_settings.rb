class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, :required => true
      t.text :value
      t.string :content_type, :default => 'Plain'

      t.timestamps
    end
    
    add_index :settings, :name, :unique => true
  end
end
