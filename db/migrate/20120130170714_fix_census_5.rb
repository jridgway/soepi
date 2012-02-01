class FixCensus5 < ActiveRecord::Migration
  def up
    change_column :census_geos, :aianhhfp, :string, :limit => 5
  end

  def down
    change_column :census_geos, :aianhhfp, :string, :limit => 3
  end
end
