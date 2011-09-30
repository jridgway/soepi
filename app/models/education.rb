class Education < ActiveRecord::Base
  has_many :targets
  has_many :members
  has_many :participant_surveys

  default_scope order('position asc')
end
