class FixReports2 < ActiveRecord::Migration
  def up
    rename_column :reports, :results, :output
    rename_column :reports, :body, :introduction
    add_column :reports, :conclusion, :text
    drop_table :assets
    create_table "report_plots", :force => true do |t|
      t.integer  "report_id",      :null => false
      t.text     "description"
      t.integer  "position"
      t.string   "plot"
      t.string   "plot_uid"
      t.string   "plot_mime_type"
      t.string   "plot_name"
      t.integer  "plot_size"
      t.integer  "plot_width"
      t.integer  "plot_height"
      t.string   "plot_image_uid"
      t.string   "plot_image_ext"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    rename_column :reports, :output, :results
    rename_column :reports, :introduction, :body
    remove_column :reports, :conclusion
    drop_table :report_plots
    create_table "assets", :force => true do |t|
      t.integer  "member_id",      :null => false
      t.integer  "assetable_id",   :null => false
      t.string   "assetable_type", :null => false
      t.string   "title"
      t.text     "body"
      t.string   "file"
      t.string   "file_uid"
      t.string   "file_mime_type"
      t.string   "file_name"
      t.integer  "file_size"
      t.integer  "file_width"
      t.integer  "file_height"
      t.string   "file_image_uid"
      t.string   "file_image_ext"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
