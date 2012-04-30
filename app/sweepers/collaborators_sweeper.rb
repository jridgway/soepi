class CollaboratorsSweeper < ActionController::Caching::Sweeper
  observe Collaborator

  def after_save(collaborator)
    case collaborator.collaborable_type.downcase
      when 'survey' then
        expire_action survey_questions_url(:survey_id => collaborator.collaborable)
    end
  end

  def after_destroy(collaborator)
    case collaborator.collaborable_type.downcase
      when 'survey' then
        expire_action survey_questions_url(:survey_id => collaborator.collaborable)
    end
  end
end