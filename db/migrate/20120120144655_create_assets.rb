class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :assetable_type
      t.integer :assetable_id
      t.string :file
      t.string :file_uid
      t.string :file_mime_type
      t.string :file_name
      t.integer :file_size
      t.integer :file_width
      t.string :file_height
      t.string :file_image_uid
      t.string :file_image_ext

      t.timestamps
    end
  end
end
