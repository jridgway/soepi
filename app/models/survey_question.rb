class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey
  has_many :choices, :class_name => 'SurveyQuestionChoice', :dependent => :destroy
  has_many :responses, :class_name => 'ParticipantResponse', :dependent => :destroy, :foreign_key => 'question_id'
  belongs_to :parent_choice, :class_name => 'SurveyQuestionChoice', :foreign_key => 'survey_question_choice_id'

  accepts_nested_attributes_for :choices, :allow_destroy => true

  default_scope order('position asc, created_at asc')

  validates_presence_of :body, :qtype
  validates_length_of :choices, :minimum => 2, :if => proc {|a| ['Select One', 'Select Multiple'].include? a['qtype']},
    :message => 'you must provide at least 2 choices'
  validate :uniq_choices
  validates_uniqueness_of :body, :message => 'you already added this question', :scope => :survey_id

  before_create :set_position
  after_create :set_positions_other_others
  after_save :clear_choices!, :unless => Proc.new {|q| ['Select One', 'Select Multiple'].include? q.qtype}
  #after_save Proc.new {|q| q.survey.update_tank_indexes}
  #after_destroy Proc.new {|q| q.survey.update_tank_indexes}

  scope :roots, where('survey_question_choice_id is null or survey_question_choice_id = 0')
  scope :choice_qtype, where("qtype = 'Select One' or qtype = 'Select Multiple'")

  def uniq_choices
    if choices.collect(&:label).uniq.length < choices.length
      errors.add :choices, 'duplicates are not allowed'
    end
  end

  def has_children?
    choices.each do |choice|
      if choice.questions.count > 0
        return true
      end
    end
    return false
  end

  def path
    if parent_choice
      "#{parent_choice.question.path}.#{position + 1}"
    else
      "#{position + 1}"
    end
  end

  def self.qtype_options
    [
      ['Multiple Choice',
        [['Select One', 'Select One'],
        ['Select Mutiple', 'Select Multiple']]
      ],
      ['Open Ended',
        [['Text','Text'],
        ['Date', 'Date'],
        ['Date/Time', 'Date/Time'],
        ['Time', 'Time'],
        ['Numeric', 'Numeric']]
      ]
    ]
  end

  private

    def set_position
      if parent_choice
        self.position = parent_choice.question.position + parent_choice.child_questions.count + 1
      else
        self.position = survey.questions.count
      end
    end

    def set_positions_other_others
      survey.questions.update_all('position = position + 1', ['position >= ? and id != ?', position, id])
    end

    def clear_choices!
      choices.destroy_all
    end
end
