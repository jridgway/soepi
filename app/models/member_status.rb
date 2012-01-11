class MemberStatus < ActiveRecord::Base
  belongs_to :member
  has_and_belongs_to_many :member_references, :class_name => 'Member'
  
  acts_as_taggable
  
  validates_presence_of :body, :member_id
  
  before_create :set_member_references
  after_create :notify!
  
  default_scope order('created_at desc')
  
  protected
  
    def set_member_references
      body.scan(/@\w+/) do |nickname|
        if (member_referenced = Member.find_by_nickname(nickname[1..-1])) and member_referenced.id != member_id
          member_references << member_referenced
        end
      end
    end
  
    def notify!
      member.member_followers.each {|m| m.notify!(self, "#{member.nickname}'s status was updated")}
      member_references.each {|m| m.notify!(self, "#{member.nickname} wrote about you")}
    end
end
