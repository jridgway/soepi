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
    attachments.inline['respond.gif'] = File.read(Rails.root.join('app', 'assets', 'images', 'respond.gif'))
    inline_layout_images
    mail(:to => member.email, :subject => "New Message")
  end

  def collaboration_key(collaborator)
    @collaborator = collaborator
    @member = collaborator.collaborable.member
    inline_layout_images
    mail(:to => collaborator.email, :subject => "Collaborate with #{@member.nickname}")
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
