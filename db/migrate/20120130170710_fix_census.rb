class FixCensus < ActiveRecord::Migration
  def up
    change_column :census_geos, :logrecno, :string, :limit => 7
  end

  def down
    change_column :census_geos, :logrecno, :string, :limit => 3
  end
end
