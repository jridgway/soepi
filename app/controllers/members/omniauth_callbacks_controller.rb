class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def method_missing(provider)
    if Member.omniauth_providers.index(provider)
      omniauth = request.env["omniauth.auth"]
      member_token = MemberToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
      if member_token
        sign_in_and_redirect(:member, member_token.member)        
        unless session[:survey_ids].empty?
          Survey.where('id in (?) and (member_id = 0 or member_id is null)', session[:survey_ids]).
            update_all "member_id = #{current_member.id}"
          session[:survey_ids] = nil
        end
      elsif member_signed_in?
        current_member.tokens.create(:provider => omniauth['provider'], :uid => omniauth['uid'].to_s)
        flash[:notice] = "Sign in token created."
        redirect_to after_sign_in_path_for(:member)
      else
        member = Member.new
        omniauth_extra = omniauth['extra'] || {}
        omniauth_user_hash = omniauth_extra['user_hash'] || {}
        member.apply_omniauth(omniauth, omniauth_user_hash)
        if member.save
          flash[:notice] = "Signed in successfully."
          sign_in_and_redirect(:member, member)
        else
          session[:omniauth] = omniauth.except('extra')
          session[:omniauth_user_hash] = {
              'email' => omniauth_user_hash['email'],
              'name' => omniauth_user_hash['name'],
              'timezone' => omniauth_user_hash['timezone'],
              'locale' => omniauth_user_hash['locale'],
              'gender' => omniauth_user_hash['gender']
            }
          redirect_to new_member_registration_url
        end
      end
    end
  end
end
