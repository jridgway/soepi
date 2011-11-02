class Target < ActiveRecord::Base
  belongs_to :targetable, :polymorphic => true
  has_and_belongs_to_many :surveys
  has_and_belongs_to_many :age_groups
  has_and_belongs_to_many :genders
  has_and_belongs_to_many :ethnicities
  has_and_belongs_to_many :races
  has_and_belongs_to_many :educations
end
