class AddSlugToRScripts < ActiveRecord::Migration
  def change
    add_column :r_scripts, :slug, :string
  end
end
