class Slide < ActiveRecord::Base
  image_accessor :img
  validates_size_of :img, :maximum => 3.megabytes 
  validates_property :mime_type, :of => :img, :in => %w(image/jpeg image/png image/gif image/tiff), 
    :message => 'must be a jpg, png, gif, or tiff image'
    
  default_scope order('position asc, publish_at desc')
  scope :live, lambda {
    where('(publish_at is null or publish_at <= ?) and (expires_at is null or expires_at >= ?)', Time.now, Time.now)
  }
end
