class AddParticipantSurveyId < ActiveRecord::Migration
  def up
    add_column :participant_responses, :participant_survey_id, :integer
  end

  def down
    remove_column :participant_responses, :participant_survey_id
  end
end
