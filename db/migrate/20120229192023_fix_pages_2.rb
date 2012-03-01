class FixPages2 < ActiveRecord::Migration
  def up
    add_column :pages, :url, :string
    add_column :pages, :path, :string
  end

  def down
    remove_column :pages, :url
    remove_column :pages, :path
  end
end
