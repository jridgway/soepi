class Member < ActiveRecord::Base
  has_many :surveys_posted, :class_name => 'Survey', :dependent => :destroy
  has_and_belongs_to_many :surveys_taken, :class_name => 'Survey'
  has_many :notifications, :dependent => :destroy
  has_many :messages, :dependent => :nullify
  has_many :message_members, :class_name => 'MessageMember', :dependent => :nullify
  has_many :messages_received, :through => :message_members, :source => :message
  has_many :charts, :dependent => :destroy
  has_many :petitions, :dependent => :destroy
  has_many :petitions_taken, :class_name => 'Petitioner', :foreign_key => :member_id, :dependent => :destroy
  has_many :tokens, :class_name => 'MemberToken', :dependent => :destroy
  belongs_to :gender
  has_and_belongs_to_many :ethnicities
  has_and_belongs_to_many :races
  belongs_to :education

  scope :confirmed, where('confirmed_at is not null')
  scope :admins, where(:admin => true)
  scope :listable, where('privacy_dont_list_me = false or privacy_dont_list_me is null')
  scope :publishers, where(%{
      exists (select * from surveys where member_id = members.id) or
      exists (select * from petitions where member_id = members.id) or
      exists (select * from charts where member_id = members.id)
    })

  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  acts_as_mappable
  acts_as_taggable
  acts_as_followable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
    :omniauthable, :confirmable, :token_authenticatable, :lockable, :authentication_keys => [:email]

  include Tanker
  tankit 'soepi' do
    indexes :text do
      "#{nickname} #{state} #{country}"
    end
    indexes :nickname
    indexes :state
    indexes :country
    indexes :id
    indexes :published do
      confirmed? and not privacy_dont_list_me?
    end
  end
  #after_save Proc.new { |m|
  #  if m.nickname_changed? or m.state_changed? or m.country_changed? or m.confirmed_at_changed?
  #    update_tank_indexes
  #  end
  #}
  #after_destroy :delete_tank_indexes

  attr_accessor :remove_pic, :pin
  attr_protected :admin

  attr_accessible :remove_pic, :pic, :email, :password, :password_confirmation, :remember_me,
    :nickname, :first_name, :last_name, :email, :phone, :address_1, :address_2,
    :city, :state, :postal_code, :country, :timezone, :primary_language,
    :gender_id, :birthmonth, :ethnicity_ids, :race_ids, :education_id, :informed_consent, :terms_of_use,
    :subscription_surveys, :subscription_charts, :subscription_petitions, :subscription_groups, :subscription_messages,
    :subscription_news, :tag_list, :privacy_dont_use_my_gravatar, :privacy_dont_list_me, :privacy_dont_show_location

  image_accessor :pic
  validates_size_of :pic, :maximum => 3.megabytes 
  validates_property :mime_type, :of => :pic, :in => %w(image/jpeg image/png image/gif image/tiff), 
    :message => 'must be a jpg, png, gif, or tiff image'

  validates_presence_of :nickname, :city, :state, :postal_code, :country,
    :timezone, :language, :birthmonth, :gender_id, :ethnicity_ids, :race_ids, :education_id
  validates_uniqueness_of :nickname
  validate :unallowed_nicknames
  validates_length_of :nickname, :minimum => 3, :maximum => 15, :allow_blank => true
  validates_format_of :nickname, :with => /^[a-z]+[a-z0-9\.]*$/i, :allow_blank => true,
    :message => 'must begin with a letter and may not contain spaces or punctuation marks'
  validates_acceptance_of :informed_consent, :terms_of_use, :accept => true

  before_create :set_year_registered
  before_save :geocode_address
  after_create :generate_and_deliver_pin!

  def unallowed_nicknames
    if %w{soepi admin administrator epi}.include? nickname.to_s.downcase.strip
      errors.add :nickname, 'this nickname is not allowed'
    end
  end

  def set_year_registered
    self.year_registered = Time.now.year if new_record?
  end

  def geocode_address
    geo = Geokit::Geocoders::MultiGeocoder.geocode "#{address_1}, #{city}, #{state} #{postal_code}, #{country}"
    self.lat, self.lng = geo.lat, geo.lng if geo.success
  end
  
  def notify!(notifiable, message, seen=false)
    notification = Notification.new 
    notification.member = self
    notification.notifiable = notifiable
    notification.message = message
    notification.seen = seen
    notification.save!
    notification
  end
  
  def may_follow?(followable)
    false if (followable.is_a?(Member) and followable.id == self.id) or 
      (not followable.is_a?(Member) and followable.member_id == self.id)
  end
  
  def follow_toggle!(followable)
    if following?(followable)
      stop_following(followable)
      following = false
      member_followers.each {|m| m.notify!(followable, "#{member.nickname} stopped following #{followable.class.to_s.downcase}, #{followable.human}.")}
    else
      follow(followable)
      following = true
      member_followers.each {|m| m.notify!(followable, "#{member.nickname} began following #{followable.class.to_s.downcase}, #{followable.human}.")}
    end
    following
  end

  def generate_and_deliver_pin!
    self.pin = ActiveSupport::SecureRandom.hex(2)
    chars = %w{2 3 4 5 7 8 9 a b c d e f g h i j k m n p q r s w x z}
    %w{1 6 i I o O 0 1 l L t T u U v V}.each do |i|
      self.pin.gsub!(i, chars.sample)
    end
    Participant.create :member => self
    Mailer.pin(self).deliver
  end

  def apply_omniauth(omniauth, omniauth_user_hash)
    case omniauth['provider']
      when 'facebook' then
        self.first_name = omniauth['user_info']['first_name'] if first_name.blank?
        self.last_name = omniauth['user_info']['last_name'] if last_name.blank?
        if omniauth_user_hash
          self.email = omniauth_user_hash['email'] if email.blank?
          if gender.blank? and (gender=Gender.find_by_label(omniauth_user_hash['gender'].titleize))
            self.gender = gender
          end
          if timezone.blank?
            self.timezone = ActiveSupport::TimeZone.all.select {|z| z.utc_offset/3600 == omniauth_user_hash['timezone'].to_i}.first.name
          end
          self.language = omniauth_user_hash['locale'] if language.blank?
        end
      when 'twitter' then
        if omniauth_user_hash
          self.first_name = omniauth_user_hash['name'].split.first if first_name.blank?
          self.last_name = omniauth_user_hash['name'].split.last if last_name.blank?
        end
      when 'linked_in', 'google' then
        self.first_name = omniauth['user_info']['first_name'] if first_name.blank?
        self.last_name = omniauth['user_info']['last_name'] if last_name.blank?
        self.email = omniauth['user_info']['email'] if email.blank?
      else
        self.email = omniauth['user_info']['email'] if omniauth['user_info'] and email.blank?
    end
    tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
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

  def password_required?
    (tokens.empty? || !password.blank? || !password_confirmation.blank?) && super
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def address
    "#{address_1} #{address_2}, #{city}, #{state} #{postal_code}, #{country}"
  end
  
  def location
    "#{state}, #{country}"
  end
  
  def email_for_gravatar
    if privacy_dont_use_my_gravatar? 
      "m.#{member.nickname}@soepi.org" 
    else
      email
    end
  end
  
  def human 
    nickname
  end
  
  def age_group
    years = ((Time.now - birthmonth.to_time) / 60 / 60 / 24 / 365).floor
    AgeGroup.where('min <= ? and max >= ?', years, years).first
  end
  
  def region
    Region.where('label like ?', "%#{state}%").first
  end
end
