class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  belongs_to :member
  
  image_accessor :file
  validates_size_of :file, :maximum => 5.megabytes 
  validates_property :mime_type, :of => :file, :in => %w(text/plain application/pdf image/jpeg image/png image/gif image/tiff image/svg+xml), 
    :message => 'must be a txt, pdf, jpg, png, gif, tiff, or svg file type'
end
