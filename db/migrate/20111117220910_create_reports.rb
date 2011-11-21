class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :member_id, :null => false
      t.string :title, :null => false
      t.text :body, :null => false
      t.string :state, :default => 'drafting'
      t.string :slug

      t.timestamps
    end
    
    create_table :assets do |t|
      t.integer :member_id, :null => false
      t.integer :assetable_id, :null => false
      t.string :assetable_type, :null => false
      t.string :title
      t.text :body
      t.string :file
      t.string :file_uid
      t.string :file_mime_type
      t.string :file_name
      t.integer :file_size
      t.integer :file_width
      t.integer :file_height
      t.string :file_image_uid
      t.string :file_image_ext

      t.timestamps
    end
    
    add_index :reports, :slug, :unique => true
  end
end
