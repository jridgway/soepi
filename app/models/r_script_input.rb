class RScriptInput < ActiveRecord::Base
  belongs_to :r_script
  
  validates_presence_of :name, :description, :r_script_id
  validates_format_of :name, :with => /^[a-z]+[a-z0-9\.]*$/i, :allow_blank => true,
    :message => 'must begin with a letter and may not contain spaces or punctuation marks'
  validates_length_of :name, :minimum => 3, :maximum => 60, :allow_blank => true
  validates_uniqueness_of :name, :scope => :r_script_id
  
  before_create :set_position
  
  protected
  
    def set_position
      self.position = r_script.inputs.count + 1
    end
end
