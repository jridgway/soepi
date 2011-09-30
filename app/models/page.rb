class Page < ActiveRecord::Base
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
end
