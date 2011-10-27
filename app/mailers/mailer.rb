require 'open-uri'

class Mailer < Devise::Mailer
  default from: "no-reply@soepi.org"
  layout 'mailer'
  
  def pin(member)
    inline_layout_images
    mail to: member.email
  end

  def notifications(member, notifications2)
    @member = member
    @notifications = notifications2
    inline_layout_images
    setup_mail(member, :notifications)
  end

  def message3(member, message2)
    @member = member
    @message = message2
    results = open avatar_url(@message.member, 60)
    @avatar_key = @message.member.nickname + '.' + results.content_type.split('/').last
    attachments.inline[@avatar_key] = results.read
    attachments.inline['respond.gif'] = File.read(Rails.root.join('app', 'assets', 'images', 'respond.gif'))
    inline_layout_images
    setup_mail(member, :message3)
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
