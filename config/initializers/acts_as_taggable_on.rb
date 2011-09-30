ActsAsTaggableOn::Tag.class_eval do
  has_friendly_id :name, :use_slug => true
end
