require 'zip/zip'

class SurveyDownload < ActiveRecord::Base
  belongs_to :survey
  
  file_accessor :asset
  validates_size_of :asset, :maximum => 500.megabytes 
  
  validates_presence_of :survey_id, :title
  
  default_scope order('position asc')
  
  before_validation :generate_file!
  
  @@demos = [Gender, AgeGroup, Region, Ethnicity, Race]
  
  def self.generate_for_survey!(survey)
    survey.downloads.create :dtype => 'completes', :position => 3
    survey.downloads.create :dtype => 'incompletes', :position => 5
    survey.downloads.create :dtype => 'data_dictionary', :position => 7
    survey.downloads.create :dtype => 'all', :position => 1
    survey.downloads.create :dtype => 'completes_compressed', :position => 2
    survey.downloads.create :dtype => 'incompletes_compressed', :position => 4
    survey.downloads.create :dtype => 'data_dictionary_compressed', :position => 6
  end
  
  protected
    
    def generate_file!
      case dtype
        when 'completes' then 
          self.title = 'All Completes'
          self.asset = generate_completes_file!
        when 'incompletes' then 
          self.title = 'All Incompletes'
          self.asset = generate_incompletes_file!
        when 'data_dictionary' then 
          self.title = 'Data Dictionary'
          self.asset = generate_data_dictionary_file!
        when 'all' then 
          self.title = 'All Completes, Incompletes, and Data Dictionary - Compressed'
          self.asset = generate_all_file_compressed! 
        when 'completes_compressed' then 
          self.title = 'All Completes - Compressed'
          self.asset = generate_completes_file_compressed!
        when 'incompletes_compressed' then 
          self.title = 'All Incompletes - Compressed'
          self.asset = generate_incompletes_file_compressed!
        when 'data_dictionary_compressed' then 
          self.title = 'Data Dictionary - Compressed'
          self.asset = generate_data_dictionary_file_compressed!
      end
    end  
    
    def weight(participant)
      1
    end 
    
    def question_ids
      @@question_ids ||= survey.questions.select('id').collect(&:id)
    end
  
    def generate_completes_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv")
      CSV.open(filename, "wb") do |csv|
        csv << get_headers
        pages = (ParticipantSurvey.for_survey(survey.id).completes.count / 1000).ceil
        (0..pages).each do |page|
          ParticipantSurvey.for_survey(survey.id).completes.page(page).per(1000).each do |participant_survey|
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
          ParticipantSurvey.for_survey(survey.id).incompletes.page(page).per(1000).each do |participant_survey|
            csv << get_row(participant_survey, question_ids)
          end
        end
      end
      Pathname.new filename
    end  
    
    def generate_data_dictionary_file!
      filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")
      File.open(filename, 'wb') do |f|
        f.write "Data dictionary goes here...\n"
      end
      Pathname.new filename
    end
    
    def generate_all_file_compressed!
      from_filenames = [
          Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv"),
          Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.csv"),
          Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")
        ]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_completes_file_compressed!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-completes.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_incompletes_file_compressed!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-incompletes.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def generate_data_dictionary_file_compressed!
      from_filenames = [Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.csv")]
      to_filename = Rails.root.join("tmp/soepi-survey-#{survey.id}-data-dictionary.zip")
      zip_files!(from_filenames, to_filename)
      to_filename
    end
    
    def get_headers
      headers = [
        'Participant Anonymous Key',
        'Gender',
        'Age Group',
        'City',
        'State',
        'Postal Code',
        'Country',
        'Region',
        'Races',
        'Ethnicities',
        'Education',
        'Weight'
      ] 
      headers += question_ids.collect {|id| "Question ID: #{id}"} 
    end
    
    def get_row(participant_survey)
      row = [
          participant_survey.participant.anonymous_key,
          participant_survey.gender.label,
          participant_survey.age_group.label,
          participant_survey.city,
          participant_survey.state,
          participant_survey.postal_code,
          participant_survey.country,
          participant_survey.region.try(:label),
          participant_survey.races.collect(&:label).join(', '),
          participant_survey.ethnicities.collect(&:label).join(', '),
          participant_survey.education.label,
          participant_survey.weight
        ]
      responses = ParticipantResponse.where('question_id in (?) and participant_id = ?', question_ids, Participant.first.id)
      question_ids.each do |question_id|
        if response = participant_survey.participant.responses.where(:question_id => question_id).first
          case response.question.qtype
            when 'Select One' then row << response.single_choice_id
            when 'Select Multiple' then row << response.multiple_choice_ids
            when 'Text' then row << response.text_response
            when 'Date', 'Date/Time', 'Time' then row << response.datetime_response
            when 'Numeric' then row << response.numeric_response
          end
        else
          row << nil
        end
      end
      row
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
end
