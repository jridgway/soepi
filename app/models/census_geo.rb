class CensusGeo < ActiveRecord::Base
  belongs_to :census
  has_one :profile, :class_name => 'CensusGeoProfile', :primary_key => 'logrecno', :foreign_key => 'logrecno'
  reverse_geocoded_by :intptlat, :intptlon
end
