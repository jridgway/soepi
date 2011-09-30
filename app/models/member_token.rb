class MemberToken < ActiveRecord::Base
  belongs_to :member

  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end
end
