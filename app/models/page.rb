class Page < ActiveRecord::Base
  validates_presence_of :title
  
  include Tanker
  tankit 'soepi' do
    indexes :text do
      "#{title} : #{body}"
    end
    indexes :id
    indexes :published do
      live?
    end
  end
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes
  
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  def body_title
    if use_custom_title?
      custom_title
    else
      title
    end
  end
end
