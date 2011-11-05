class Region < ActiveRecord::Base
  has_and_belongs_to_many :targets
  has_many :participant_surveys

  default_scope order('position asc')
end
