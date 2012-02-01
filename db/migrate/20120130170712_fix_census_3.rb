class FixCensus3 < ActiveRecord::Migration
  def up
    change_column :census_geos, :metdiv, :string, :limit => 5
  end

  def down
    change_column :census_geos, :metdiv, :string, :limit => 3
  end
end
