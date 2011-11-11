class AddRaceEthnicityIds < ActiveRecord::Migration
  def up
    add_column :participant_surveys, :race_ids_cache, :string
    add_column :participant_surveys, :ethnicity_ids_cache, :string
  end

  def down
    remove_column :participant_surveys, :race_ids_cache
    remove_column :participant_surveys, :ethnicity_ids_cache
  end
end
