class Report < ActiveRecord::Base
  belongs_to :member
  belongs_to :r_script
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
    text :body
    text :nickname do 
      member.nickname
    end
    text :assets do 
      assets.collect {|a| a.title + ' ' + a.description}.join(', ') 
    end
    string :state
    integer :id
  end
end
