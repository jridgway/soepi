class RScript < ActiveRecord::Base
  belongs_to :member
  has_many :forks, :class_name => 'RScript', :foreign_key => :forked_from_id
  belongs_to :forked_from, :class_name => 'RScript'
  has_many :reports

  acts_as_taggable
  acts_as_followable
  
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates :title, :presence => true
  validates :description, :presence => true
  
  default_scope order('created_at desc')
  scope :pending, where(:state => 'pending')
  scope :passing, where(:state => 'passing')
  scope :failing, where(:state => 'failing')
  scope :not_pending, where("state != 'pending'")

  def posted_by
    member.nickname if member
  end
  
  def human 
    title
  end
  
  searchable do
    text :title
    text :description
    text :nickname do 
      member.nickname
    end
    text :code
    string :state
    integer :id
  end
  
  attr_protected :state

  state_machine :state, :initial => :pending do
    state :pending
    state :passing
    state :failing

    event :passed do
      transition [:pending, :passing, :failing] => :passing
    end

    event :failed do
      transition [:pending, :failing, :passing] => :failing
    end
  end
  
  def state_human
    case state
      when 'pending' then 'Pending'
      when 'passing' then 'Passing'
      when 'failing' then 'Failing'
    end
  end
  
  def forkit!(member_id)
    RScript.transaction do 
      new_r_script = self.dup
      new_r_script.forked_from = self
      new_r_script.member_id = member_id 
      new_r_script.state = 'pending'
      new_r_script.tag_list = tag_list
      new_r_script.save!
      return new_r_script
    end
  end
end
