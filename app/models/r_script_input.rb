class RScriptInput < ActiveRecord::Base
  belongs_to :r_script
  belongs_to :survey
  
  validates_presence_of :name, :description, :r_script_id, :itype
  validates_format_of :name, :with => /^[a-z]+[a-z0-9\_]*$/i, :allow_blank => true,
    :message => 'must begin with a letter and may not contain spaces or punctuation marks'
  validates_length_of :name, :minimum => 3, :maximum => 60, :allow_blank => true
  validates_uniqueness_of :name, :scope => :r_script_id
  
  validate :default_value
  
  before_create :set_position
  
  attr_accessor :survey_label
  
  def survey_label
    if self[:survey_label].nil?
      survey.title if survey
    else
      self[:survey_label]
    end
  end
  
  def default_value
    case itype 
      when 'Survey results' then
        errors.add :survey_label, 'cannot be blank' if survey.nil?
      when 'Character' then
        errors.add :default_character, 'cannot be blank' if default_character.blank?
      when 'Numeric' then
        errors.add :default_numeric, 'cannot be blank' if default_numeric.nil?
    end
  end
  
  protected
  
    def set_position
      self.position = r_script.inputs.count + 1
    end
end
