class Part < ActiveRecord::Base
  validates_presence_of :name
  
  def self.find_or_set(name, body='', raw=false)
    unless part = find_by_name(name)
      part = create(:name => name, :body => body, :raw => raw)
    end
    part.update_attribute :raw, raw if part.raw != raw
    part.body
  end
  
  def self.set(name, body, raw=false)
    if part = find_by_name(name)
      part.update_attributes :body => body, :raw => raw
    else
      part = create(:name => name, :body => body, :raw => raw)
    end
    part.body
  end
  
  def self.set?(name)
    true if (part = find_by_name(name)) and not part.body.blank?
  end
end
