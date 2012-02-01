class CensusGeoProfile < ActiveRecord::Base
  belongs_to :geo, :class_name => 'CensusGeo', :primary_key => 'logrecno', :foreign_key => 'logrecno'
end
