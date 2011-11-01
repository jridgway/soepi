class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :description
      t.integer :position
      t.datetime :publish_at, :default => 'now()'
      t.datetime :expires_at
      t.string :img 
      t.string :img_uid
      t.string :img_mime_type
      t.string :img_name
      t.integer :img_size
      t.integer :img_width
      t.integer :img_height
      t.string :img_image_uid
      t.string :img_image_ext

      t.timestamps
    end
  end
end
