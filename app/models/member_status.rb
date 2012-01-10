class MemberStatus < ActiveRecord::Base
  belongs_to :member
  has_and_belongs_to_many :member_references, :class_name => 'Member'
  
  acts_as_taggable
  
  validates_presence_of :body, :member_id
  
  after_create :notify!
  
  default_scope order('created_at desc')
  
  protected
  
    def notify!
      member.member_followers.each {|m| m.notify!(self, "#{member.nickname}'s status was updated:")}
    end
end
