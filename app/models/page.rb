class Page < ActiveRecord::Base
  has_many :assets, :as => :assetable
  belongs_to :member
  
  validates_presence_of :title
  
  searchable do
    text :title
    text :body
    boolean :published do 
      true unless state == 'drafting'
    end
    integer :id
  end
  
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  def body_title
    if use_custom_title?
      custom_title
    else
      title
    end
  end
  
  def human 
    title
  end
end
