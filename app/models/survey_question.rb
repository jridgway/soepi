class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey
  has_many :choices, :class_name => 'SurveyQuestionChoice', :dependent => :destroy
  has_many :responses, :class_name => 'ParticipantResponse', :dependent => :destroy, :foreign_key => 'question_id'
  belongs_to :parent_choice, :class_name => 'SurveyQuestionChoice', :foreign_key => 'survey_question_choice_id'
  has_many :survey_downloads
  
  include Extensions::SurveyQuestionForDiff
  
  amoeba do 
    enable
    include_field :choices
  end

  accepts_nested_attributes_for :choices, :allow_destroy => true

  default_scope order('position asc, created_at asc')

  validates_presence_of :body, :qtype, :label
  validates_length_of :label, :maximum => 50
  validates_length_of :choices, :minimum => 2, :if => proc {|a| ['Select One', 'Select Multiple'].include? a['qtype']},
    :message => 'you must provide at least 2 choices'
  validate :uniq_choices
  validates_uniqueness_of :body, :message => 'you already added this question', :scope => :survey_id
  validates_uniqueness_of :label, :scope => :survey_id

  before_create :init_position
  before_save :set_boolean_choices
  before_update :update_position
  after_create :init_other_positions
  after_update :update_other_positions, :tidy_positions
  after_destroy :tidy_positions
  after_save :clear_choices!, :unless => Proc.new {|q| ['Yes/No', 'True/False', 'Select One', 'Select Multiple'].include? q.qtype}

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
      "#{parent_choice.question.path}.#{position}"
    else
      "#{position}"
    end
  end

  def self.qtype_options
    [
      ['Multiple Choice',
        [['Yes/No', 'Yes/No'],
        ['True/False', 'True/False'],
        ['Select One', 'Select One'],
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
  
  def r_name
    if qtype == 'Select Multiple'
      h = {}
      choices.each {|c| h[c.id] = ["#{label} - #{c.label}", r_format("#{label} #{c.label}")]}
      h
    else
      [label, r_format(label)]
    end
  end
  
  def response_totals(page=1, per=10)
    case qtype
      when 'Select One', 'Yes/No', 'True/False' then
        totals = ParticipantSurvey.joins('join participant_responses pr on pr.participant_id = participant_surveys.participant_id').
          where('survey_id = ? and complete = ? and pr.question_id = ?', survey_id, true, id).
          group('pr.single_choice_id').count
        choices.collect {|c| {:label => c.label, :id => c.id, :total => (totals[c.id.to_s] || 0)}}
      when 'Select Multiple' then
        totals = ParticipantSurvey.joins('join participant_responses pr on pr.participant_id = participant_surveys.participant_id ' +
            'join participant_responses_survey_question_choices prsqc on prsqc.participant_response_id = pr.id').
          where('survey_id = ? and complete = ? and pr.question_id = ?', survey_id, true, id).
          group('prsqc.survey_question_choice_id').count
        choices.collect {|c| {:label => c.label, :id => c.id, :total => (totals[c.id.to_s] || 0)}}
      when 'Numeric' then
        totals = {}     
        totals[:count] = responses.count
        if totals[:count] > 0
          totals[:min] = responses.select('numeric_response').order('numeric_response asc').first.numeric_response.to_f.round(2) 
          if (low_row = totals[:count] / 4) > 0 
            totals[:low] = responses.select('numeric_response').order('numeric_response asc').limit(low_row).last.numeric_response.to_f.round(2)
          end
          if (median_row = totals[:count] / 2) > 0
            totals[:median] = responses.select('numeric_response').order('numeric_response asc').limit(median_row).last.numeric_response.to_f.round(2)
          end
          if (high_row = (totals[:count] / 1.33).floor) > 0
            totals[:high] = responses.select('numeric_response').order('numeric_response asc').limit(high_row).last.numeric_response.to_f.round(2)
          end
          totals[:max] = responses.select('numeric_response').order('numeric_response asc').last.numeric_response.to_f.round(2) 
          totals[:avg] = connection.exec_query(%{select avg(numeric_response) as numeric_response
            from participant_responses where question_id = #{id}}).first['numeric_response'].to_f.round(2) 
          totals[:mode] = connection.exec_query(%{select numeric_response, count(*)
            from participant_responses where question_id = #{id}
            group by numeric_response
            order by count(*) desc
            limit 1}).first['numeric_response'].to_f.round(2) 
          totals[:stddev] = connection.exec_query(%{select stddev(numeric_response) as numeric_response
            from participant_responses where question_id = #{id}}).first['numeric_response'].to_f.round(2) 
        end
        totals
      when 'Date', 'Date/Time', 'Time' then
        totals = {}     
        totals[:count] = responses.count
        if totals[:count] > 0
          totals[:min] = responses.select('datetime_response').order('datetime_response asc').first.datetime_response.to_datetime
          if (low_row = totals[:count] / 4) > 0 
            totals[:low] = responses.select('datetime_response').order('datetime_response asc').limit(low_row).last.datetime_response.to_datetime
          end
          if (median_row = totals[:count] / 2) > 0
            totals[:median] = responses.select('datetime_response').order('datetime_response asc').limit(median_row).last.datetime_response.to_datetime
          end
          if (high_row = (totals[:count] / 1.33).floor) > 0
            totals[:high] = responses.select('datetime_response').order('datetime_response asc').limit(high_row).last.datetime_response.to_datetime
          end
          totals[:max] = responses.select('datetime_response').order('datetime_response asc').last.datetime_response.to_datetime
          totals[:avg] = connection.exec_query(%{select TIMESTAMP with time zone 'epoch' + avg(extract(epoch from datetime_response)) * interval '1 second' as datetime_response
            from participant_responses where question_id = #{id}}).first['datetime_response'].to_datetime
          totals[:mode] = connection.exec_query(%{select datetime_response, count(*)
            from participant_responses where question_id = #{id}
            group by datetime_response
            order by count(*) desc
            limit 1}).first['datetime_response'].to_datetime
        end
        totals
      when 'Text' then
        responses.page(page).per(per)
    end
  end
  
  def next_question
    survey.questions.where('position = ?', position + 1).first
  end
  
  def previous_question
    survey.questions.where('position = ?', position - 1).first
  end

  private
    
    def r_format(s)
      s2 = s.strip.gsub(/\s+/, ' ').gsub(/\W/, '.')
    end

    def init_position
      if parent_choice
        if parent_choice.child_questions.count == 0
          self.position = parent_choice.question.position + 1
        else
          self.position = parent_choice.child_questions.last.position + 1
        end
      else
        self.position = survey.questions.count + 1
      end
    end

    def init_other_positions
      survey.questions.update_all('position = position + 1', ['position >= ? and id != ?', position, id])
    end
    
    def update_position
      if survey_question_choice_id_changed?
        init_position
      end
    end
    
    def update_other_positions
      if survey_question_choice_id_changed?
        init_other_positions
      end
    end
    
    def tidy_positions
      survey.questions.each_with_index do |question, index|
        index_2 = index + 1 
        if question.position != index_2
          question.update_attribute :position, index_2
        end
      end
    end
    
    def set_boolean_choices
      choices.destroy_all if not new_record? and qtype_changed?
      if choices.empty?
        case qtype
          when 'Yes/No' then
            choices.build :label => 'Yes', :value => 1, :position => 1
            choices.build :label => 'No', :value => 0, :position => 2
          when 'True/False' then
            choices.build :label => 'True', :value => 1, :position => 1
            choices.build :label => 'False', :value => 0, :position => 2
        end
      end
    end

    def clear_choices!
      choices.destroy_all
    end
end
