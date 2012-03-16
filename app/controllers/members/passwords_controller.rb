class Members::PasswordsController < Devise::PasswordsController
  protected
      
    def after_sending_reset_password_instructions_path_for(resource_name)
      if resource_name.is_a?(Member) or resource_name == :member
        main_app.new_member_session_path
      else
        super
      end
    end
end