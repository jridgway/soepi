module ApplicationHelper 
  def sub_menu_page
    unless @sub_menu_page
      if @page.present? 
        @sub_menu_page = @page.self_and_ancestors.where(:depth => 1).first
      end
    end
    @sub_menu_page
  end
  
  def sub_menu_page_roots
    unless @sub_menu_page_roots
      @sub_menu_page_roots = refinery_menu_pages.select {|m| m.parent_id == sub_menu_page.id}
    end
    @sub_menu_page_roots
  end

  def page_breadcrumbs(page)
    if page.ancestors.empty?
      page.title
    else
      (page.ancestors.collect {|p| link_to(p.title, refinery.url_for(p.url))}.join(' &raquo; ') +
      ' &raquo; ' + page.title).html_safe
    end
  end
 
  def home?
    true if request.path == '/'
  end
  
  def controller_for_tag(tag)
    case tag.taggings.first.taggable_type 
      when 'Survey' then '/surveys'
      when 'Report' then '/reports'
      when 'Member' then '/members/profiles'
      when 'MemberStatus' then '/members/statuses'
      when 'Page' then '/pages'
    end
  end
  
  def browser_title_2(title)
    if title.blank? and @page.present? 
      title = @page.title
    end
    if title.blank?
      Refinery::Core.site_name
    else
      "#{title} - #{Refinery::Core.site_name}"
    end
  end
  
  def meta_description_2(description)
    if description.blank? and @page.present? 
      description = @page.meta_description
    end
    if description.blank?
      Refinery::Setting.find_or_set(:meta_description, '')
    else
      description
    end
  end
  
  def meta_keywords_2(keywords)
    if keywords.blank? and @page.present? 
      keywords = @page.meta_keywords
    end
    if keywords.blank?
      Refinery::Setting.find_or_set(:meta_keywords, '')
    else
      keywords
    end
  end
  
  def states
    Country.new('US').states.collect {|s| s.last['name']}.sort {|a,b| a <=> b}
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
      when 'MemberStatus' then controller = '/members/statuses'
      when 'Survey' then controller = '/surveys'
      when 'Report' then controller = '/reports'
      when 'Page' then controller = '/pages'
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
      link_to img, main_app.member_path(member), :title => member.nickname, :class => 'avatar'
    else
      img
    end
  end
  
  def followable_link(followable, remote=false, redirect_to_url=request.url)
    if followable.is_a?(Member)
      owner_id = followable.id 
    else
      owner_id = followable.member_id
    end
    link_to 'Follow', 
      follow_toggle_path(:followable_type => followable.class.to_s, :followable_id => followable.id, :redirect_to_url => redirect_to_url), 
      :method => :put, 
      :remote => remote, 
      :id => 'follow-toggle', 
      :class => 'button restrict-to-members not-owner', 
      :'data-member-id' => owner_id,
      :icon => 'ui-icon-star',
      :followable_type => followable.class.to_s, 
      :followable_id => followable.id
  end
  
  def facets_chosen
    s = [:gender, :age_group, :races, :ethnicities, :education].select {|f| params[f]}.collect do |facet_name|
      "<strong>#{params[facet_name]}</strong> (#{link_to 'Remove', params.except(facet_name)})"
    end.join(', ').html_safe
    if s.blank?
      'None, choose from the right column.'
    else
      s
    end
  end
  
  def format_and_link_member_references(body)
    link_member_references(auto_link(simple_format(strip_tags(body))))
  end
  
  def link_member_references(body)
    body_2 = body
    body.scan(/@\w+/) do |nickname|
      if member_referenced = Member.where('nickname ilike ?', nickname[1..-1]).first
        body_2 = body_2.gsub(/#{nickname}\b/, link_to("@#{member_referenced.nickname}", member_path(member_referenced)))
      end
    end
    body_2
  end
end
