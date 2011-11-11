class FixParticipantSurveys2 < ActiveRecord::Migration
  def up
    remove_column :participant_surveys, :remove_city
    remove_column :participant_surveys, :remove_state
    remove_column :participant_surveys, :remove_postal_code
    remove_column :participant_surveys, :remove_region
    add_column :participant_surveys, :old_city, :string
    add_column :participant_surveys, :old_state, :string
    add_column :participant_surveys, :old_postal_code, :string
    add_column :participant_surveys, :old_region_id, :integer
  end

  def down
    add_column :participant_surveys, :remove_city, :boolean, :default => false
    add_column :participant_surveys, :remove_state, :boolean, :default => false
    add_column :participant_surveys, :remove_postal_code, :boolean, :default => false
    add_column :participant_surveys, :remove_region, :boolean, :default => false
    remove_column :participant_surveys, :old_city
    remove_column :participant_surveys, :old_state
    remove_column :participant_surveys, :old_postal_code
    remove_column :participant_surveys, :old_region_id
  end
end
