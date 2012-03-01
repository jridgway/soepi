class Census < ActiveRecord::Base
  self.table_name = 'censuses'
  has_many :geos, :class_name => 'CensusGeo'
end
