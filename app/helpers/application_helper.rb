module ApplicationHelper
  def browser_title(title)
    if title.blank? and @page.present? 
      if @page.browser_title.blank?
        if @page.use_custom_title?
          title = @page.custom_title
        else
          title = @page.title
        end
      else
        title = @page.browser_title
      end
    end
    if title.blank?
      Setting.find_or_set(:site_name, 'SoEpi Inc')
    else
      "#{title} - #{Setting.find_or_set(:site_name, 'SoEpi Inc')}"
    end
  end
  
  def meta_description(description)
    if description.blank? and @page.present? 
      description = @page.meta_description
    end
    if description.blank?
      Setting.find_or_set(:meta_description, '')
    else
      description
    end
  end
  
  def meta_keywords(keywords)
    if keywords.blank? and @page.present? 
      keywords = @page.meta_keywords
    end
    if keywords.blank?
      Setting.find_or_set(:meta_keywords, '')
    else
      keywords
    end
  end

  def priority_countries
    ['United States']
  end

  def timeago(datetime)
    %{<abbr class="timeago" title="#{datetime.iso8601}">#{datetime.strftime('%A, %B %d, %Y at %I:%m %p')}</abbr>}.html_safe
  end

  def tag_list_links(record)
    case record.class.to_s
      when 'Member' then controller = '/members/profiles'
      else controller = '/' + record.class.to_s.downcase.pluralize
    end
    unless record.tags.empty?
      record.tags.collect {|t| link_to(t, url_for(:controller => controller, :action => 'by_tag', :tag => t), :class => 'tag')}.join(' ').html_safe
    end
  end

  def avatar(member, size=100, linked=true)
    if member.pic.nil?
      img = gravatar_image_tag(member.email_for_gravatar, :class => 'avatar', :alt => member.nickname, :width => size, :height => size, :gravatar => {:size => size})
    else
      img = image_tag(member.pic.thumb("#{size}x#{size}#").url, :class => 'avatar', :alt => member.nickname)
    end
    if linked
      link_to img, member_path(member), :title => member.nickname
    else
      img
    end
  end
  
  def followable_link(followable, remote=false)
    if followable.is_a?(Member)
      owner_id = followable.id 
    else
      owner_id = followable.member_id
    end
    link_to 'Follow', 
      follow_toggle_path(:followable_type => followable.class.to_s, :followable_id => followable.id), 
      :method => :put, 
      :remote => remote, 
      :id => 'follow-toggle', 
      :class => 'button restrict-to-members not-owner', 
      :'data-member-id' => owner_id,
      :icon => 'ui-icon-star',
      :followable_type => followable.class.to_s, 
      :followable_id => followable.id
  end
  
  def page_entries_info(collection, options = {})
    collection_name = options[:collection_name] || (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))

    if collection.num_pages < 2
      case collection.size
      when 0; info = "No #{collection_name.pluralize} found"
      when 1; info = "Displaying <strong>1</strong> #{collection_name}"
      else;   info = "Displaying <strong>all #{collection.size}</strong> #{collection_name.pluralize}"
      end
    else
      info = %{Displaying #{collection_name.pluralize} <strong>%d&ndash;%d</strong> of <strong>%d</strong> in total}% [
        collection.offset_value + 1,
        collection.offset_value + collection.length,
        collection.total_count
      ]
    end
    info.html_safe
  end
end
