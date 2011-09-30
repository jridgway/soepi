class AgeGroup < ActiveRecord::Base
  has_and_belongs_to_many :targets

  default_scope order('min asc')
end
