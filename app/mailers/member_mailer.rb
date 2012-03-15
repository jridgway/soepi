require 'open-uri'

class MemberMailer < ActionMailer::Base
  default :from => "no-reply@soepi.org"
  layout 'mailer'

  def new_notifications(member, notifications)
    @member = member
    @notifications = notifications
    inline_layout_images
    mail(:to => member.email, :subject => "Notifications")
  end

  def new_message(member, message)
    @member = member
    @message = message
    results = open avatar_url(@message.member, 60)
    @avatar_key = @message.member.nickname + '.' + results.content_type.split('/').last
    attachments.inline[@avatar_key] = results.read
    attachments.inline['respond.gif'] = File.read(Rails.root.join('app', 'assets', 'images', 'respond.gif'))
    inline_layout_images
    mail(:to => member.email, :subject => "New Message")
  end

  def inline_layout_images(others={})
    attachments.inline['header.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'soepi-logo-light-bg.png'))
  end  

  def avatar_url(member, size=100)
    if member.pic.nil?
      GravatarImageTag.gravatar_url(member.email_for_gravatar, 
        :alt => member.nickname, :width => size, :height => size, :gravatar => {:size => size})
    else
      member.pic.thumb("#{size}x#{size}").url
    end
  end
end
