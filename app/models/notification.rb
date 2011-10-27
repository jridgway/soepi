class Notification < ActiveRecord::Base  
  belongs_to :notifiable, :polymorphic => true
  belongs_to :member
  
  validates_presence_of :member, :notifiable, :message
  
  default_scope order('created_at desc')
  scope :unseen, where('seen = false')
  scope :seen, where('seen = true')
  
  def self.deliver_undelivered_notifications!
    last_delivery_at = Setting.find_or_set :last_notifications_delivered_at, 1.year.ago
    Setting.set :last_notifications_delivered_at, Time.now
    member_ids = select('distinct member_id').where('created_at > ?', last_delivery_at).collect(&:member_id)
    member_ids.each do |member_id|
      member = Member.find(member_id)
      notifications = where('created_at > ? and member_id = ?', last_delivery_at, member_id)
      Mailer.notifications(member, notifications).deliver
      puts "Delivered #{notifications.length} notifications to #{member.nickname}"
    end
  rescue  
    Setting.set :last_notifications_delivered_at, last_delivery_at
  end
end
