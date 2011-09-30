class MessageMember < ActiveRecord::Base
  belongs_to :member
  belongs_to :message
  
  scope :seen, where('seen = true')
  scope :unseen, where('seen = false or seen is null')
  scope :involving_member, lambda {|member_id| where('message_members.member_id = ?', member_id)}
end
