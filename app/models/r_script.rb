class RScript < ActiveRecord::Base
  belongs_to :member
  has_many :assets, :as => :assetable

  acts_as_taggable
  acts_as_followable
  
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates :title, :presence => true, :uniqueness => true

  def posted_by
    member.nickname if member
  end
  
  def human 
    title
  end
  
  searchable do
    text :title
    text :description
    text :nickname do 
      member.nickname
    end
    text :code
    string :state
    integer :id
  end
end
