class Member < ActiveRecord::Base
  has_many :surveys, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :messages, :dependent => :nullify
  has_many :message_members, :class_name => 'MessageMember', :dependent => :nullify
  has_many :messages_received, :through => :message_members, :source => :message
  has_many :r_scripts, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  has_many :assets, :dependent => :destroy
  has_many :tokens, :class_name => 'MemberToken', :dependent => :destroy

  scope :confirmed, where('confirmed_at is not null')
  scope :admins, where(:admin => true)
  scope :listable, where('privacy_dont_list_me = false or privacy_dont_list_me is null')
  scope :publishers, where(%{
      exists (select * from surveys where member_id = members.id and state != 'drafting') or
      exists (select * from r_scripts where member_id = members.id and state != 'drafting') or
      exists (select * from reports where member_id = members.id and state != 'drafting')
    })

  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  acts_as_taggable
  acts_as_followable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
    :omniauthable, :confirmable, :token_authenticatable, :lockable

  searchable do
    text :nickname
    text :email
    boolean :published do 
      confirmed? and not privacy_dont_list_me?
    end
    integer :id
  end

  attr_accessor :remove_pic, :participant, :pin
  attr_protected :admin, :credits

  attr_accessible :remove_pic, :pic, :email, :password, :password_confirmation, :remember_me,
    :nickname, :phone, :timezone, :tag_list, :informed_consent, :terms_of_use,
    :subscription_notifications, :subscription_weekly_summaries, :subscription_messages, :subscription_news, 
    :privacy_dont_use_my_gravatar, :privacy_dont_list_me

  image_accessor :pic
  validates_size_of :pic, :maximum => 3.megabytes 
  validates_property :mime_type, :of => :pic, :in => %w(image/jpeg image/png image/gif image/tiff), 
    :message => 'must be a jpg, png, gif, or tiff image'

  validates_presence_of :nickname, :timezone
  validates_uniqueness_of :nickname
  validate :unallowed_nicknames
  validates_length_of :nickname, :minimum => 3, :maximum => 15, :allow_blank => true
  validates_format_of :nickname, :with => /^[a-z]+[a-z0-9\.]*$/i, :allow_blank => true,
    :message => 'must begin with a letter and may not contain spaces or punctuation marks'
  validates_acceptance_of :informed_consent, :terms_of_use, :accept => true

  before_create :set_year_registered
  before_destroy :destroy_ec2_instance!

  def unallowed_nicknames
    if %w{soepi admin administrator epi}.include? nickname.to_s.downcase.strip
      errors.add :nickname, 'this nickname is not allowed'
    end
  end

  def set_year_registered
    self.year_registered = Time.now.year if new_record?
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

  def password_required?
    (tokens.empty? || !password.blank? || !password_confirmation.blank?) && super
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

  def name
    nickname
  end
  
  @@connection = Fog::Compute.new(
      :provider => 'AWS', 
      :aws_secret_access_key => ENV['S3_SECRET'], 
      :aws_access_key_id => ENV['S3_KEY']
    )
  
  def get_ec2_instance
    unless ec2_instance_id.blank?
      @@connection.servers.get(ec2_instance_id)
    end
  end
  
  def create_ec2_instance!
    ec2_instance = @@connection.servers.bootstrap(
        :key_name => 'fog_production',
        :private_key => ENV['ec2_private_key'], 
        :username => 'ubuntu', 
        :image_id => 'ami-29ff3440'
      )
    update_attribute :ec2_instance_id, ec2_instance.id
    update_attribute :booting_ec2_instance, false
    update_attribute :ec2_last_accessed_at, Time.now
    ec2_instance
  end
  
  def destroy_ec2_instance!
    if ec2_instance = get_ec2_instance
      ec2_instance.destroy
    end
    update_attribute :ec2_instance_id, nil
  end
end
