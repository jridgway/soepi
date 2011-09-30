class Petition < ActiveRecord::Base
  belongs_to :member
  has_many :petitioners

  acts_as_taggable
  acts_as_followable

  has_friendly_id :title, :use_slug => true

  validates :title, :presence => true, :uniqueness => true
  validates_presence_of :description, :promise

  include Tanker
  tankit 'soepi' do
    indexes :text do
      "#{title} #{description} #{promise} #{tag_list} #{member.nickname}"
    end
    indexes :state
    indexes :id
    indexes :member do
      member.nickname
    end
    indexes :published do
      member.confirmed?
    end
  end
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def posted_by
    member.nickname if member
  end
end
