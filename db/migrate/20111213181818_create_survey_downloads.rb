class CreateSurveyDownloads < ActiveRecord::Migration
  def change
    create_table :survey_downloads do |t|
      t.integer :survey_id, :null => false
      t.string :title
      t.string :dtype
      t.integer :position
      t.string :asset
      t.string :asset_uid
      t.string :asset_mime_type
      t.string :asset_name
      t.integer :asset_size

      t.timestamps
    end
  end
end
