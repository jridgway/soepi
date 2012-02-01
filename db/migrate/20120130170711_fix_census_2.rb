class FixCensus2 < ActiveRecord::Migration
  def up
    change_column :census_geos, :cbsa, :string, :limit => 5
  end

  def down
    change_column :census_geos, :cbsa, :string, :limit => 3
  end
end
