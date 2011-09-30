class Setting < ActiveRecord::Base
  def self.find_or_set(name, value)
    if setting = find_by_name(name)
      setting
    else
      create :name => name, :value => value
    end
    value
  end
end
