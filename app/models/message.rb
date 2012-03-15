class Message < ActiveRecord::Base
  belongs_to :member
  has_many :message_members, :dependent => :destroy
  has_many :members, :through => :message_members, :source => :member, :uniq => true, 
    :select => 'members.*, lower(nickname) as lower_nickname', :order => 'lower_nickname asc'
  belongs_to :parent_message, :class_name => 'Message', :foreign_key => 'message_id'
  has_many :responses, :class_name => 'Message', :order => 'created_at asc', :dependent => :destroy
  
  attr_accessor :recipient_nicknames

  validates_presence_of :body, :member_id

  scope :roots, where('messages.message_id is null')
  scope :involving_member, lambda { |member_id| 
    joins(:message_members).merge(MessageMember.involving_member(member_id))
  }
  scope :involving_member_unseen, lambda { |member_id| 
    joins(:message_members).merge(MessageMember.involving_member(member_id).unseen)
  }
  scope :recent, order('messages.created_at desc')
  
  before_validation :set_members
  after_create :mark_parent_unseen!
  after_create :deliver_messages!
  
  validate :at_least_one_recipient
  
  def at_least_one_recipient 
    if parent_message.nil? and recipient_nicknames.empty?
      errors.add :recipient_nicknames, 'You must include at least one valid nickname' 
    end
  end
  
  def seen_by?(member_id)
    if parent_message
      parent_message.seen_by?(member_id)
    else
      true if message_members.find_by_member_id(member_id).try(:seen?)
    end
  end  
  
  def mark_seen_by_member!(member_id)
    if parent_message
      parent_message.mark_seen_by_member!(member_id)
    else
      message_members.update_all 'seen = true', ['member_id = ?', member_id]
    end
  end

  private
  
    def set_members
      unless parent_message
        new_recipient_nicknames = []
        recipient_nicknames.split(/,\s*/).each do |nickname| 
          unless nickname == member.nickname or nickname.blank?
            if recipient = Member.where('nickname ilike ? and (privacy_dont_list_me = false or privacy_dont_list_me is null)', nickname.strip).first
              self.members << recipient
              new_recipient_nicknames << recipient.nickname
            end
          end
        end
        self.members << member
        self.recipient_nicknames = new_recipient_nicknames.join(', ')
      end
    end
    
    def mark_parent_unseen!
      if parent_message
        parent_message.message_members.update_all 'seen = false', ['member_id != ?', member_id]
      end
    end

    def deliver_messages!
      if parent_message
        members_to_notify = parent_message.members.where('member_id != ?', member_id)
      else
        members_to_notify = members.where('member_id != ?', member_id)
      end
      members_to_notify.each do |member|
        if member.subscription_messages?
          MemberMailer.delay.new_message(member, self)
        end
      end
    end
end
