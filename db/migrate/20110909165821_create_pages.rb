class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :null => false
      t.text :body
      t.text :css
      t.text :javascript
      t.string :browser_title
      t.string :custom_title
      t.boolean :use_custom_title, :default => false
      t.string :meta_keywords
      t.string :meta_description
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.string :redirect_url
      t.string :state, :default => 'draft'
      t.datetime :show_at
      t.datetime :hide_at

      t.timestamps
    end
  end
end
