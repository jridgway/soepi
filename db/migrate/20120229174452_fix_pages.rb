class FixPages < ActiveRecord::Migration
  def up
    add_column :pages, :parent_id, :integer
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    add_column :pages, :depth, :integer
  end

  def down
    remove_column :pages, :parent_id
    remove_column :pages, :lft
    remove_column :pages, :rgt
    remove_column :pages, :depth
  end
end
