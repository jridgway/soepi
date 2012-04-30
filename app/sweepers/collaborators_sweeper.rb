class CollaboratorsSweeper < ActionController::Caching::Sweeper
  observe Collaborator

  def after_save(collaborator)
    case collaborator.collaborable_type.downcase
      when 'survey' then
        expire_action survey_questions_url(:survey_id => collaborator.collaborable_id)
    end
  end

  def after_destroy(survey)
    case collaborator.collaborable_type.downcase
      when 'survey' then
        expire_action survey_questions_url(:survey_id => collaborator.collaborable_id)
    end
  end
end