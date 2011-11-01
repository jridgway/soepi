class Part < ActiveRecord::Base
  validates_presence_of :name
  
  def self.find_or_set(name, body, markup_type='ckeditor')
    unless part = find_by_name(name)
      part = create(:name => name, :body => body, :markup_type => markup_type)
    end
    part.update_attribute :markup_type, markup_type if part.markup_type != markup_type
    if part.markup_type == 'ckeditor'
      part.body.to_s.html_safe
    else
      part.body.to_s
    end
  end
  
  def self.set(name, body, markup_type='ckeditor')
    if part = find_by_name(name)
      part.update_attributes :body => body, :markup_type => markup_type
    else
      part = create(:name => name, :body => body, :markup_type => markup_type)
    end
    if part.markup_type == 'ckeditor'
      part.body.to_s.html_safe
    else
      part.body.to_s
    end
  end
  
  def self.set?(name)
    true if (part = find_by_name(name)) and not part.body.blank?
  end
end
