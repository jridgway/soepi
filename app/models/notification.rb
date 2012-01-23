class Notification < ActiveRecord::Base  
  belongs_to :notifiable, :polymorphic => true
  belongs_to :member
  
  validates_presence_of :member, :notifiable, :message
  
  default_scope order('created_at desc')
  scope :unseen, where('seen = false')
  scope :seen, where('seen = true')
  
  def self.deliver_notifications!
    member_ids = with_exclusive_scope {
        where('members.subscription_notifications == true and ' +
          '(notifications.created_at > members.last_notifications_delivered_at or members.last_notifications_delivered_at is null)').
        select('distinct member_id').joins('join members on members.id = notifications.member_id').
        collect(&:member_id)
      }
    Member.find(member_ids).each do |member|
      if member.last_notifications_delivered_at.nil?
        notifications = member.notifications
      else
        notifications = member.notifications.where('created_at > ?', member.last_notifications_delivered_at)
      end
      member.update_attribute :last_notifications_delivered_at, Time.now
      Mailer.new_notifications(member, notifications).deliver
      logger.info "Delivered #{notifications.length} notifications to #{member.nickname}"
    end
  end
end
