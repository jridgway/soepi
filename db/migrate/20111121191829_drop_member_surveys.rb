class DropMemberSurveys < ActiveRecord::Migration
  def up
    drop_table :member_surveys
  end

  def down
    create_table "member_surveys", :force => true do |t|
      t.integer "member_id"
      t.integer "survey_id"
    end
  end
end
