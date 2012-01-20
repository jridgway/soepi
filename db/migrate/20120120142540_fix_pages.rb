class FixPages < ActiveRecord::Migration
  def up
    remove_column :pages, :author_nickname
    add_column :pages, :member_id, :integer
  end

  def down
    add_column :pages, :author_nickname, :string
    remove_column :pages, :member_id
  end
end
