class Survey < ActiveRecord::Base
  belongs_to :member
  has_many :members, :class_name => 'MemberSurvey'
  has_many :participants, :class_name => 'ParticipantSurvey'
  has_many :questions, :class_name => 'SurveyQuestion'
  has_many :comments, :class_name => 'SurveyComment'
  has_one :target, :as => :targetable
  has_and_belongs_to_many :targets
  has_many :forks, :class_name => 'Survey', :foreign_key => :forked_from_id
  belongs_to :forked_from, :class_name => 'Survey'
  has_many :notifications, :as => :notifiable, :class_name => 'Message'

  accepts_nested_attributes_for :target

  default_scope order('surveys.created_at desc')
  scope :drafting, where(:state => 'drafting')
  scope :review_requested, where(:state => 'review_requested')
  scope :rejected, where(:state => 'rejected')
  scope :live, where(['state in (?)', %w{published launched closed}])
  scope :live_or_drafting, where(['state in (?)', %w{drafting published launched closed}])
  scope :launched, where(:state => 'launched')
  scope :closed, where(:state => 'closed')
  scope :published, where(:state => 'published')

  acts_as_taggable
  acts_as_followable
  
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates_presence_of :title, :description, :purpose_of_survey, :uses_of_results,
    :time_required_in_minutes, :minimum_completes_needed, :closes_soft_at, :member_id
  validates_length_of :title, :minimum => 3
  validates_numericality_of :minimum_completes_needed, :maximum_completes_needed, :minimum => 300, :allow_blank => true
  validates_numericality_of :time_required_in_minutes, :cohort_interval_in_days,
    :cohort_range_in_days, :minimum => 1, :allow_blank => true
  validates_numericality_of :cohort_range_in_days, :minimum => 1, :allow_blank => true

  include Tanker
  tankit 'soepi' do
    indexes :text do
      s = "#{title} #{description} #{purpose_of_survey} #{uses_of_results} #{organization_name} #{irb_name} #{tag_list} #{member.nickname}"
      questions.each do |question|
        s += ' ' + question.body
        question.choices.each do |choice|
          s += ' ' + choice.label
        end
      end
      s
    end
    indexes :id
    indexes :state
    indexes :member do
      member.nickname
    end
    indexes :published do
      live?
    end
  end
  #after_save :update_tank_indexes
  #after_destroy :delete_tank_indexes

  def validate
    if drafting? and state_was == 'drafting'
      if closes_soft_at and closes_soft_at - Time.now < 14.days
        errors.add :closes_soft_at, 'must be at least 14 days from now'
      end
      if closes_hard_at and closes_hard_at - Time.now < 14.days
        errors.add :closes_hard_at, 'must be at least 14 days from now'
      end
      if closes_soft_at and closes_hard_at and closes_soft_at > closes_hard_at
        errors.add :closes_soft_at, 'must be earlier than Closes at hard'
      end
      if irb?
        errors.add :irb_name, 'is required if IRB is checked' if irb_name.blank?
        errors.add :irb_phone, 'is required if IRB is checked' if irb_phone.blank?
        errors.add :irb_email, 'is required if IRB is checked' if irb_email.blank?
      end
      if organization?
        errors.add :organization_name, 'is required if Organization is checked' if organization_name.blank?
        errors.add :organization_phone, 'is required if Organization is checked' if organization_phone.blank?
        errors.add :organization_email, 'is required if Organization is checked' if organization_email.blank?
      end
      if cohort?
        if cohort_interval_in_days.blank?
          errors.add :cohort_interval_in_days, 'is required if Cohort is checked'
        end
        if cohort_range_in_days.blank?
          errors.add :cohort_range_in_days, 'is required if Cohort is checked'
        end
      end
      if minimum_completes_needed and maximum_completes_needed and minimum_completes_needed > maximum_completes_needed
        errors.add :maximum_completes_needed, 'must be more than minimum completes needed'
      end
    end
  end
  
  attr_protected :state

  state_machine :state, :initial => :drafting do
    state :drafting
    state :review_requested
    state :rejected
    state :launched
    state :closed
    state :published
    state :hidden

    event :request_review do
      transition :drafting => :review_requested
    end

    event :request_changes do
      transition :review_requested => :drafting
    end

    event :reject do
      transition :review_requested => :rejected
    end

    event :launch do
      transition :review_requested => :launched
    end

    event :close do
      transition :launched => :closed
    end

    event :publish do
      transition :closed => :published
    end

    after_transition any => :review_requested do |survey, transition|
      #setup_notification('Submitted a survey for review', member)
    end

    after_transition any => :rejected do |survey, transition|
      #SurveyNotification.deliver_rejected survey
    end

    after_transition any => :launched do |survey, transition|
      #SurveyNotification.deliver_launched survey
    end

    after_transition any => :closed do |survey, transition|
      #SurveyNotification.deliver_closed survey
    end

    after_transition any => :published do |survey, transition|
      #SurveyNotification.deliver_results_published survey
    end
  end

  def live?
    %w{published launched closed}.include? state
  end

  def editable?
    true unless live? or review_requested? or rejected?
  end

  def forkit!(member_id)
    Survey.transaction do 
      new_survey = self.dup :include => [:target]
      new_survey.forked_from = self
      new_survey.member = member 
      new_survey.state = 'drafting'
      new_survey.tag_list = tag_list
      unless new_survey.target.nil?
        new_survey.target.age_groups = self.target.age_groups
        new_survey.target.genders = self.target.genders
        new_survey.target.ethnicities = self.target.ethnicities
        new_survey.target.races = self.target.races
        new_survey.target.occupations = self.target.occupations
        new_survey.target.educations = self.target.educations
      end
      new_survey.save!
      forkit_questions_helper(new_survey, self.questions.roots)
      return new_survey
    end
  end
  
  def forkit_questions_helper(survey, questions, parent_choice=nil)
    questions.each do |question|
      new_question = question.dup :include => [:choices]
      new_question.survey = survey
      new_question.parent_choice = parent_choice
      new_question.save!
      if question.qtype == 'Select Multiple' or question.qtype = 'Select One'
        question.choices.each_with_index do |choice, index|
          new_choice = new_question.choices[index]
          forkit_questions_helper(survey, choice.child_questions, new_choice)
        end
      end
    end
  end
  
  def state_human
    case state
      when 'drafting' then 'Drafting'
      when 'review_requested' then 'Review requested'
      when 'launched' then 'Open'
      when 'rejected' then 'Rejected'
      when 'closed' then 'Closed, results pending publication'
      when 'published' then 'Closed, results published'
      when 'hidden' then 'Hidden'
    end
  end

  def update_question_positions!(positions)
    index = 0
    questions_2 = {}
    questions.all.each {|q| questions_2[q.id] = q}
    positions.each_pair do |id, choice_id|
      question = questions_2[id.to_i]
      choice_id = nil if choice_id == 'root'
      if question.position != index or question.survey_question_choice_id.to_i != choice_id.to_i
        question.update_attributes :position => index, :survey_question_choice_id => choice_id
      end
      index += 1
    end
  end

  def total_surveys
    if cohort?
      if cohort_range_in_days == -1
        -1
      else
        (cohort_range_in_days / cohort_interval_in_days).floor
      end
    else
      1
    end
  end

  def total_surveys_human
    if total_surveys > 0
      total_surveys.to_s
    else
      'Indefinitely'
    end
  end

  def cohort_interval_in_days_human
    c = Survey.cohort_interval_options.select {|c| c[1] == cohort_interval_in_days}.first
    c[0].downcase if c
  end

  def cohort_range_in_days_human
    c = Survey.cohort_range_options.select {|c| c[1] == cohort_range_in_days}.first
    c[0].downcase if c
  end

  def self.time_required_options
    [
      ['Less than a minute', 1],
      ['Five minutes', 5],
      ['Ten minutes', 10],
      ['Fifteen minutes', 15],
      ['Half an hour', 30],
      ['An hour', 60],
      ['An hour and a half', 90],
      ['Two hours or more', 120]
    ]
  end

  def self.cohort_interval_options
    [
      ['Every day', 1.0],
      ['Weekly', 7.0],
      ['Every other week', 14.0],
      ['Monthly', 30.45],
      ['Every other month', 30.45 * 2],
      ['Four times a year', 30.45 * 3],
      ['Three times a year', 30.45 * 4],
      ['Two times a year', 30.45 * 6],
      ['Yearly', 365.25],
      ['Every other year', 730.5]
    ]
  end

  def self.cohort_range_options
    [
      ['One week', 7.0],
      ['Two weeks', 14.0],
      ['One month', 30.45],
      ['Two months', 30.45 * 2],
      ['Three Months', 30.45 * 3],
      ['Four Months', 30.45 * 4],
      ['Five Months', 30.45 * 5],
      ['Six Months', 30.45 * 6],
      ['One Year', 365.25],
      ['Two Years', 365.25 * 2],
      ['Indefinitely', -1.0],
    ]
  end

  def survey_question_choice_id_options(current_question_id=nil, questions=questions.roots, level=0)
    options = []
    index = 1
    questions.each do |question|
      options << ["#{'&nbsp;&nbsp;' * level}#{index}. QUESTION: #{question.body}".html_safe, {:disabled => 'disabled', :value => 0}]
      options += survey_question_choice_id_options_helper(current_question_id, question.choices, level+1)
      index += 1
    end
    options
  end

  def posted_by
    member.nickname if member
  end

  protected

    def survey_question_choice_id_options_helper(current_question_id, choices, level)
      options = []
      index = 1
      choices.each do |choice|
        if current_question_id == choice.survey_question_id
          options << ["#{'&nbsp;&nbsp;' * (level)}#{index}. CHOICE: #{choice.label}".html_safe, {:disabled => 'disabled', :value => choice.id}]
        else
          options << ["#{'&nbsp;&nbsp;' * (level)}#{index}. CHOICE: #{choice.label}".html_safe, choice.id]
        end
        options += survey_question_choice_id_options(current_question_id, choice.child_questions, level+1)
        index += 1
      end
      options
    end
end
