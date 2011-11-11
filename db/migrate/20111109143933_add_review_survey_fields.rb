class AddReviewSurveyFields < ActiveRecord::Migration
  def up
    add_column :participant_surveys, :remove_city, :boolean, :default => false
    add_column :participant_surveys, :remove_state, :boolean, :default => false
    add_column :participant_surveys, :remove_postal_code, :boolean, :default => false
    add_column :participant_surveys, :remove_region, :boolean, :default => false
    add_column :participant_surveys, :destroy_participant_survey, :boolean, :default => false
    add_column :surveys, :review_completed_at, :datetime, :default => nil
  end

  def down
    remove_column :participant_surveys, :remove_city
    remove_column :participant_surveys, :remove_state
    remove_column :participant_surveys, :remove_postal_code
    remove_column :participant_surveys, :remove_region
    remove_column :participant_surveys, :destroy_participant_survey
    remove_column :surveys, :review_completed_at
  end
end
