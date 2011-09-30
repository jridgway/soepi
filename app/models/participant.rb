require 'digest/sha1'

class Participant < ActiveRecord::Base
  has_many :responses, :class_name => 'ParticipantResponse', :dependent => :destroy
  has_many :surveys, :class_name => 'ParticipantSurvey', :dependent => :destroy

  before_create :set_anonymous_key

  attr_accessor :member

  def self.find_by_member(member)
    find_by_anonymous_key generate_anonymous_key(member)
  end

  private

  def set_anonymous_key
    self.anonymous_key = Participant.generate_anonymous_key(member)
  end

  def self.generate_anonymous_key(member)
    Digest::SHA1.hexdigest "#{member.id}-#{member.year_registered}-#{member.pin}-#{ENV['SoEpi_PIN_EXTRA']}"
  end
end
