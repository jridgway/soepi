class FixCensus4 < ActiveRecord::Migration
  def up
    change_column :census_geos, :place, :string, :limit => 5
  end

  def down
    change_column :census_geos, :place, :string, :limit => 3
  end
end
