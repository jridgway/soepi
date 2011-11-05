class RemoveBirthMonthParticipantSurveys < ActiveRecord::Migration
  def up
    remove_column :participant_surveys, :birthmonth
    add_column :participant_surveys, :age_group_id, :integer
  end

  def down
    add_column :participant_surveys, :birthmonth, :date
    remove_column :participant_surveys, :age_group_id
  end
end
