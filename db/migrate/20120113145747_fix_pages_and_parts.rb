class FixPagesAndParts < ActiveRecord::Migration
  def up
    remove_column :pages, :parent_id
    remove_column :pages, :lft
    remove_column :pages, :rgt
    remove_column :pages, :markup_type
    remove_column :pages, :show_at
    remove_column :pages, :hide_at
    add_column :pages, :raw, :boolean, :default => false
    add_column :pages, :author_nickname, :string
    remove_column :parts, :markup_type
    add_column :parts, :raw, :boolean, :default => false
  end
  
  def down
    add_column :pages, :parent_id, :integer
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    add_column :pages, :markup_type, :string, :default => 'plain'
    add_column :pages, :show_at, :datetime
    add_column :pages, :hide_at, :datetime
    remove_column :pages, :raw
    remove_column :pages, :author_nickname
    add_column :parts, :markup_type, :string, :default => 'plain'
    remove_column :parts, :raw
  end
end
