class Chart < ActiveRecord::Base
  belongs_to :member

  validates :title, :presence => true, :uniqueness => true

  acts_as_taggable
  acts_as_followable

  has_friendly_id :title, :use_slug => true

  include Tanker
  tankit 'soepi' do
    indexes :text do
      "#{title} #{description} #{tag_list} #{member.nickname}"
    end
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
