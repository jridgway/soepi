class Page < ActiveRecord::Base
  has_many :assets, :as => :assetable
  belongs_to :member
  
  validates_presence_of :title
  
  acts_as_nested_set
  attr_protected :lft, :rgt, :depth, :path, :url
  
  before_save :set_path, :set_url
  after_save :clear_cache
  after_destroy :clear_cache
  
  scope :published, where('state = ?', 'published')
  
  searchable do
    text :title
    text :body
    boolean :published do 
      true unless state == 'drafting'
    end
    integer :id
  end
  
  extend FriendlyId
  friendly_id :title, :use => [:scoped, :slugged], :scope => :parent
  
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
  
  def to_param
    url
  end
  
  protected 
    
    def set_path
      self.path = set_path_helper
    end
    
    def set_path_helper
      if parent
        parent.set_path_helper + ' &raquo; ' + title
      else
        title
      end
    end
    
    def set_url
      self.url = set_url_helper
    end
    
    def set_url_helper
      if parent
        parent.set_url_helper + '/' + slug
      else
        slug
      end
    end
    
    def clear_cache
      Rails.cache.write :pages_cache_expirary_key, rand.to_s[2..-1]
    end
end
