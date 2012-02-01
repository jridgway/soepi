class FixCensus7 < ActiveRecord::Migration
  def up
    change_column :census_geos, :cousub, :string, :limit => 5
    change_column :census_geos, :necta, :string, :limit => 5
    change_column :census_geos, :nectadiv, :string, :limit => 5
  end

  def down
    change_column :census_geos, :cousub, :string, :limit => 3
    change_column :census_geos, :necta, :string, :limit => 3
    change_column :census_geos, :nectadiv, :string, :limit => 3
  end
end
