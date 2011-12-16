class CreateReportsSurveys < ActiveRecord::Migration
  def up
    create_table :reports_surveys, :id => false, :force => true do |t|
      t.integer :report_id
      t.integer :survey_id
    end
  end

  def down
    drop_table :reports_surveys
  end
end
