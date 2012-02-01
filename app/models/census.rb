class Census < ActiveRecord::Base
  set_table_name 'censuses'
  has_many :geos, :class_name => 'CensusGeo'
end
