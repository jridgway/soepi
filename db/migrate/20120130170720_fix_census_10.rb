class FixCensus10 < ActiveRecord::Migration
  def up
    change_column :census_geos, :zcta5, :string, :limit => 5
  end

  def down
    change_column :census_geos, :zcta5, :string, :limit => 3
  end
end
