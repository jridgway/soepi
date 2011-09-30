class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :name
      t.text :body
      t.string :url_regex
      t.text :css
      t.text :javascript
      t.datetime :show_at
      t.datetime :hide_at
      t.string :state, :default => 'draft'
      t.datetime :show_at
      t.datetime :hide_at

      t.timestamps
    end
  end
end
