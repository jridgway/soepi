class FixCensus6 < ActiveRecord::Migration
  def up
    change_column :census_geos, :anrc, :string, :limit => 5
  end

  def down
    change_column :census_geos, :anrc, :string, :limit => 3
  end
end
