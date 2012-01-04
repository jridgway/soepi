require 'zip/zip'

class SurveyDownload < ActiveRecord::Base
  belongs_to :survey
  belongs_to :question, :class_name => 'SurveyQuestion'
  
  file_accessor :asset
  validates_size_of :asset, :maximum => 500.megabytes 
  
  validates_presence_of :survey_id, :title
  
  default_scope order('position asc')
  
  before_validation :generate_file!
  
  @@demos = [Gender, AgeGroup, Region, Ethnicity, Race]
  
  def self.generate_for_survey!(survey)
    survey.downloads.create :dtype => 'completes', :position => 2
    survey.downloads.create :dtype => 'incompletes', :position => 3
    survey.downloads.create :dtype => 'data_dictionary', :position => 4
    survey.questions.each_with_index do |question, index|
      survey.downloads.create :dtype => 'question', :question_id => question.id, :position => index + 5
    end
    survey.downloads.create :dtype => 'all', :position => 1
  end
  
  protected
    
    def generate_file!
      case dtype
        when 'all' then 
          self.title = 'All Completes, Incompletes, Individual Questions, and Data Dictionary'
          self.asset = generate_all_file_compressed! 
        when 'completes' then 
          self.title = 'All Completes'
          self.asset = generate_completes_file_compressed!
        when 'incompletes' then 
          self.title = 'All Incompletes'
          self.asset = generate_incompletes_file_compressed!
        when 'question' then 
          self.title = "#{question.label}"
          self.asset = generate_question_file_compressed!
        when 'data_dictionary' then 
          self.title = 'Data Dictionary'
          self.asset = generate_data_dictionary_file_compressed!
      end
    end  
    
    def weight(participant)
      1
    end 
    
    def generate_completes_file_compressed!
      generate_completes_file!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_incompletes_file_compressed!
      generate_incompletes_file!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_question_file_compressed!
      generate_question_file!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-question-#{question.id}.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-question-#{question.id}.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_data_dictionary_file_compressed!
      generate_data_dictionary_file!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_all_file_compressed!
      from_filenames = [
          Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv"),
          Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.csv"),
          Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")
        ]
      from_filenames += survey.questions.collect do |question|
        "tmp/soepi-survey-#{survey.id}-question-#{question.id}.csv"
      end
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-all.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
  
    def generate_completes_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv")
      CSV.open(filename, "wb") do |csv|
        csv << get_headers
        pages = (ParticipantSurvey.for_survey(survey.id).completes.count / 1000).ceil
        (0..pages).each do |page|
          ParticipantSurvey.for_survey(survey.id).completes.includes(:participant, :responses).page(page).per(1000).each do |participant_survey|
            csv << get_row(participant_survey)
          end
        end
      end
      Pathname.new filename
    end
  
    def generate_incompletes_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.csv")
      CSV.open(filename, "wb") do |csv|
        csv << get_headers
        pages = (ParticipantSurvey.for_survey(survey.id).incompletes.count / 1000).ceil
        (0..pages).each do |page|
          ParticipantSurvey.for_survey(survey.id).incompletes.includes(:participant, :responses).page(page).per(1000).each do |participant_survey|
            csv << get_row(participant_survey)
          end
        end
      end
      Pathname.new filename
    end  
  
    def generate_question_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-question-#{question.id}.csv")
      questions_count = survey.questions.length
      question_index = survey.questions.index {|q| q.id == question.id}
      columns_to_delete = (0..(questions_count-1)).collect {|i| question_index != i ? 12 + i : nil}.compact.reverse
      CSV.open(filename, "wb") do |csv|
        CSV.foreach(Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv")) do |csv2|
          columns_to_delete.each do |i|
            csv2.slice!(i)
          end
          csv << csv2
        end
      end
      Pathname.new filename
    end 
    
    def generate_data_dictionary_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")
      CSV.open(filename, "wb") do |csv|
        csv << ['R.Name', 'Label', 'Question.ID', 'Question.Type', 'Question.Body', 
          'Question.Dependent.On', 'Question.Required', 'Question.Choice.IDs', 'Question.Choice.Labels']
        survey.questions.each do |question|
          if question.qtype == 'Select Multiple'
            r_names = question.r_name
            question.choices.each do |choice|
              csv << [r_names[choice.id].second, r_names[choice.id].first, question.id, question.qtype, 
                question.body, (question.parent_choice.nil? ? nil : question.parent_choice.r_name.second), 
                (question.required? ? 'Yes' : 'No'), choice.id, choice.label]
            end
          else
            csv << [question.r_name.second, question.label, question.id, question.qtype, 
              question.body, (question.parent_choice.nil? ? nil : question.parent_choice.r_name.second), 
              (question.required? ? 'Yes' : 'No'), question.choice_ids.join(', '), "* " + question.choices.collect(&:label).join("\n* ")]
          end
        end
      end
      Pathname.new filename
    end
    
    def get_headers
      headers = [
          'Participant.Anonymous.Key',
          'Gender',
          'Age.Group',
          'City',
          'State',
          'Postal.Code',
          'Country',
          'Region'
        ]
      headers += Race.all.collect {|r| r_format "Race #{r.label}"}
      headers += Ethnicity.all.collect {|e| r_format "Ethnicity #{e.label}"}
      headers += [
          'Education',
          'Weight'
        ]
      headers += questions.collect do |question| 
        if question.qtype == 'Select Multiple'
          r_names = question.r_name
          question.choices.collect {|c| r_names[c.id].second}
        else
          question.r_name.second
        end
      end.flatten
    end
    
    def get_row(participant_survey)
      row = [
          participant_survey.participant.anonymous_key,
          participant_survey.gender_id,
          participant_survey.age_group_id,
          participant_survey.city,
          participant_survey.state,
          participant_survey.postal_code,
          participant_survey.country,
          participant_survey.region_id
        ]
      row += Race.all.collect {|r| participant_survey.race_ids.include?(r.id) ? 1 : 0}
      row += Ethnicity.all.collect {|e| participant_survey.ethnicity_ids.include?(e.id) ? 1 : 0}
      row += [
          participant_survey.education_id,
          participant_survey.weight
        ]
      responses = participant_survey.responses
      questions.each do |question|
        if response = responses.select {|r| r.question_id == question.id}.first
          case question.qtype
            when 'True/False', 'Yes/No' then row << response.single_choice.try(:boolean_code)
            when 'Select One' then row << response.single_choice_id
            when 'Select Multiple' then row += question.choices.collect {|c| response.multiple_choice_ids.include?(c.id) ? 1 : 0}
            when 'Text' then row << response.text_response
            when 'Date', 'Date/Time', 'Time' then row << response.datetime_response
            when 'Numeric' then row << response.numeric_response
          end
        else
          if question.qtype == 'Select Multiple'
            row << question.choices.count.times.collect {nil}
          else
            row << nil 
          end
        end
      end
      row
    end
    
    def questions      
      if question.nil?
        @@questions ||= survey.questions.includes(:choices)
      else
        @@questions ||= [question]
      end
    end
    
    def zip_files!(from_filenames, to_filename)
      Zip::ZipOutputStream.open(to_filename) do |zos|
        from_filenames.each do |from_filename|
          zos.put_next_entry(File.basename(from_filename))
          zos.puts File.read(from_filename)
        end
      end
      to_filename
    end
    
    def r_format(s)
      s2 = s.strip.gsub(/\s+|\W+/, ' ').strip.gsub(/\W+/, '.')
    end
end
