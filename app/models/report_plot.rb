class ReportPlot < ActiveRecord::Base
  belongs_to :report
  
  default_scope order('position desc, created_at asc')
  
  image_accessor :plot
  validates_size_of :plot, :maximum => 5.megabytes 
  validates_property :mime_type, :of => :plot, :in => %w(text/plain application/pdf image/jpeg image/png image/gif image/tiff image/svg+xml), 
    :message => 'must be a txt, pdf, jpg, png, gif, tiff, or svg plot type'
end
