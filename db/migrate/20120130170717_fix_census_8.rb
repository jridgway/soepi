class FixCensus8 < ActiveRecord::Migration
  def up
    change_column :census_geos, :concit, :string, :limit => 5
  end

  def down
    change_column :census_geos, :concit, :string, :limit => 3
  end
end
