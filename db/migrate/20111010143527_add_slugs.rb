class AddSlugs < ActiveRecord::Migration
  def up
    [:pages, :surveys, :charts, :petitions, :members, :tags].each do |table|
      add_column table, :slug, :string
      add_index table, :slug, :uniq => true
    end
  end

  def down
    [:pages, :surveys, :charts, :petitions, :members, :tags].each do |table|
      remove_index table, :slug
      remove_column table, :slug
    end
  end
end
