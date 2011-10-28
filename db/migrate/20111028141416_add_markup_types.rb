class AddMarkupTypes < ActiveRecord::Migration
  def up
    add_column :pages, :markup_type, :string
    add_column :parts, :markup_type, :string
  end

  def down
    remove_column :pages, :markup_type
    remove_column :parts, :markup_type
  end
end
