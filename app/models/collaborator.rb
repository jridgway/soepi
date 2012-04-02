class Collaborator < ActiveRecord::Base
  belongs_to :collaborable, :polymorphic => true
  belongs_to :member
  
  before_validation :set_member
  before_create :set_key
  after_create :invite!
  
  validate :validate_email_or_nickname, :validate_valid_nickname, :owner_not_collaborator, :on => :create
  validates_uniqueness_of :member_id, :email, :allow_blank => true, :scope => [:collaborable_type, :collaborable_id],
    :message => 'You already added this collaborator'
  validates_format_of :email, :allow_blank => true, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
    :message => 'Not a valid email'
  
  attr_accessor :nickname
  
  protected
    
    def set_member
      if not nickname.blank? and member = Member.listable.where('lower(nickname) = ? ', nickname.downcase).first
        self.member_id = member.id
        self.active = true
      end
    end
    
    def validate_email_or_nickname
      if email.blank? and nickname.blank?
        errors.add :nickname, 'You must provide an email or a nickname'
      elsif not email.blank? and not nickname.blank? 
        errors.add :nickname, 'You must provide only an email or only a nickname, not both'
      end
    end
    
    def validate_valid_nickname
      if not nickname.blank? and member_id.to_i == 0
        errors.add :nickname, 'Not a valid nickname'
      end
    end
    
    def owner_not_collaborator
      puts "sdafsadfsadfsdaf"
      puts "#{member_id} == #{collaborable.member_id}"
      unless member_id.blank?
        if member_id == collaborable.member_id
          errors.add :nickname, 'You cannot add the owner as a collaborator'
        end
      end
    end
    
    def set_key
      unless email.blank?
        self.key = SecureRandom.base64(100).gsub(/[^a-z-A-Z0-9]/, '')[0..49]
      end
    end
    
    def invite!
      unless email.blank? or key.blank?
        MemberMailer.delay.collaboration_key(self)
      end
    end
end
