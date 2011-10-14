class Setting < ActiveRecord::Base
  validates_presence_of :name
  
  def self.find_or_set(name, value)
    unless setting = find_by_name(name)
      setting =  create :name => name, :value => value
    end
    setting.value
  end
end
