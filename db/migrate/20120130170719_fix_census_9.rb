class FixCensus9 < ActiveRecord::Migration
  def up
    remove_column :census_geos, :logrecno
    remove_column :census_geo_profiles, :logrecno
    add_column :census_geos, :logrecno, :integer
    add_column :census_geo_profiles, :logrecno, :integer
  end

  def down
    remove_column :census_geos, :logrecno
    remove_column :census_geo_profiles, :logrecno
    add_column :census_geos, :logrecno, :string, :limit => 7
    add_column :census_geo_profiles, :logrecno, :string, :limit => 7
  end
end
