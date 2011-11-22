require 'digest/sha1'

class Participant < ActiveRecord::Base
  has_many :responses, :class_name => 'ParticipantResponse', :dependent => :destroy
  has_many :surveys, :class_name => 'ParticipantSurvey', :dependent => :destroy
  belongs_to :gender
  belongs_to :age_group
  belongs_to :region
  has_and_belongs_to_many :ethnicities
  has_and_belongs_to_many :races
  belongs_to :education
  
  validates_presence_of :city, :state, :postal_code, :country, 
    :birthmonth, :gender_id, :ethnicity_ids, :race_ids, :education_id
  validates_presence_of :pin, :on => :create
  validates_length_of :pin, :minimum => 6, :allow_blank => true, :on => :create

  attr_accessor :member, :pin
  
  geocoded_by :location, :latitude => :lat, :longitude => :lng
  
  extend FriendlyId
  friendly_id :anonymous_key

  before_create :set_anonymous_key
  after_validation :geocode
  after_destroy :clear_statistics
  
  searchable do
    string :anonymous_key
    string :gender do 
      gender.label
    end
    string :age_group do 
      age_group.label
    end
    string :education do 
      education.label
    end
    string :races, :multiple => true do 
      races.collect(&:label)
    end
    string :ethnicities, :multiple => true do 
      ethnicities.collect(&:label)
    end
    string :surveys_taken do 
      surveys.collect(&:survey).collect(&:title).join(', ')
    end
    string :city
    string :state
    string :postal_code
    string :country
    string :region do 
      region.label if region
    end
    string :surveys_taken, :multiple => true do 
      surveys.collect(&:survey).collect(&:title)
    end
    integer :id
  end

  def location
    [city, state, postal_code, country].compact.join(', ')
  end

  def deliver_pin!
    Mailer.pin(self).deliver
  end

  def self.find_by_member(member)
    find_by_anonymous_key generate_anonymous_key(member)
  end
  
  def has_taken_survey?(survey_id)
    true if surveys.where(:survey_id => survey_id, :complete => true).count > 0
  end
  
  def age_group
    years = ((Time.now - birthmonth.to_time) / 60 / 60 / 24 / 365).floor
    AgeGroup.where('min <= ? and max >= ?', years, years).first
  end
  
  def region
    Region.where('label like ?', "%#{state}%").first
  end

  def qualifies_for_survey?(survey)
    target = survey.target
    qualifies = true
    if target
      if target.target_by_location?
        case target.location_type
          when 'address' then
            unless target.city.blank? or target.city != member.city
              qualifies = false
            end
            unless target.state.blank? or target.state != member.state
              qualifies = false
            end
            unless target.postal_code.blank? or target.postal_code != member.postal_code
              qualifies = false
            end
            unless target.country.blank? or target.country != member.country
              qualifies = false
            end
        when 'vicinity' then
          if Member.where(:id => self.id).within(target.radius, :origin => [target.lat, target.lng]).count == 0
            qualifies = false
          end
        when 'region' then
          region_id = region.id
          if target.region_ids.select {|r_id| r_id == region_id}.length == 0
            qualifies = false
          end          
        end
      end
      if target.target_by_age_group? and target.age_group_ids.length > 0
        age_group_id = age_group.id
        if target.age_group_ids.select {|a_id| a_id == age_group_id}.length == 0
          qualifies = false
        end
      end
      if target.target_by_gender? and target.gender_ids.length > 0
        if target.gender_ids.select {|g_id| g_id == gender_id}.length == 0
          qualifies = false
        end
      end
      if target.target_by_education? and target.education_ids.length > 0
        if target.education_ids.select {|e_id| e_id == education_id}.length == 0
          qualifies = false
        end
      end
      if target.target_by_ethnicity? and target.ethnicity_ids.length > 0
        if target.ethnicity_ids.select {|e_id| ethnicity_ids.include?(e_id)}.length == 0
          qualifies = false
        end
      end
      if target.target_by_race? and target.race_ids.length > 0
        if target.race_ids.select {|r_id| race_ids.include?(r_id)}.length == 0
          qualifies = false
        end
      end
    end
    qualifies
  end

  private

    def set_anonymous_key
      unless pin.blank? or member.nil?
        self.anonymous_key = Participant.generate_anonymous_key(member)
      end
    end
  
    def self.generate_anonymous_key(member)
      Digest::SHA1.hexdigest "#{member.id}-#{member.year_registered}-#{member.pin}-#{ENV['SoEpi_PIN_EXTRA']}"
    end
    
    def clear_statistics
      Statistic.delete_all
    end
end
