class RScript < ActiveRecord::Base
  include ActionView::Helpers::JavaScriptHelper
  
  belongs_to :member
  has_many :inputs, :class_name => 'RScriptInput'
  has_many :forks, :class_name => 'RScript', :foreign_key => :forked_from_id
  belongs_to :forked_from, :class_name => 'RScript'
  has_many :reports
  
  accepts_nested_attributes_for :inputs
  
  before_create :init_code

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
  
  def inputs_code(actual=true)
    "# Based on the inputs provided, the following code #{actual ? 'will' : 'was'} be appended to your \n# code prior to execution. #{actual ? "Default values will be replaced when necessary.\n" : ''}" +
    inputs.collect do |input|
      case input.itype
        when 'Survey results' then 
          if input.survey
            "#{input.name}_completes_temp <- tempfile() \ndownload.file('#{ENV['domain']}#{input.survey.completes_download.asset.url}', #{input.name}_completes_temp) \n" +
            "#{input.name}_incompletes_temp <- tempfile() \ndownload.file('#{ENV['domain']}#{input.survey.incompletes_download.asset.url}', #{input.name}_incompletes_temp) \n" +
            "#{input.name}_data_dictionary_temp <- tempfile() \ndownload.file('#{ENV['domain']}#{input.survey.data_dictionary_download.asset.url}', #{input.name}_data_dictionary_temp) \n" +
            "#{input.name} <- list(completes=read.csv(unzip(#{input.name}_completes_temp)), incompletes=read.csv(unzip(#{input.name}_incompletes_temp)), data_dictionary=read.csv(unzip(#{input.name}_data_dictionary_temp))) "
          end
        when 'Character' then 
          "#{input.name} <- '#{escape_javascript(input.default_character)}' "
        when 'Numeric' then
          "#{input.name} <- #{input.default_numeric} "
      end
    end.compact.join("\n\n") + "\n"
  end
  
  protected
    
    def init_code
      self.code = "# Your code goes here\n\nhello_world <- function(arg1) {\n  print(arg1)\n}\n\nhello_world('hello world');"
    end
end
