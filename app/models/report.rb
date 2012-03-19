class Report < ActiveRecord::Base
  belongs_to :member
  has_many :plots, :class_name => 'ReportPlot', :dependent => :destroy
  belongs_to :forked_from, :class_name => 'Report'
  has_many :forks, :class_name => 'Report', :foreign_key => :forked_from_id, :dependent => :nullify
  has_and_belongs_to_many :surveys
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  belongs_to :job, :class_name => '::Delayed::Job', :foreign_key => :job_id 
  
  accepts_nested_attributes_for :plots

  acts_as_taggable
  acts_as_followable
  
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates :title, :presence => true
  
  before_create :init_code
  before_save :set_survey_references
  
  default_scope order('created_at desc')
  scope :pending, where(:state => 'pending')
  scope :preparing_to_run, where(:state => 'preparing_to_run')
  scope :running, where(:state => 'running')
  scope :passing, where(:state => 'passing')
  scope :failing, where(:state => 'failing')
  scope :published, where(:state => 'published')

  def posted_by
    member.nickname if member
  end
  
  def human 
    title
  end
  
  searchable do
    text :title, :boost => 5.0
    text :introduction
    text :conclusion
    text :code
    text :output
    text :nickname do 
      member.nickname
    end
    text :plots do 
      plots.collect {|a| a.description}.join(', ') 
    end
    boolean :published do 
      true
    end
    string :state
    integer :id
  end
  
  handle_asynchronously :solr_index
  
  state_machine :state, :initial => :pending do
    state :running
    state :passing
    state :failing
    state :published 

    event :run do
      transition [:pending, :passing, :failing, :published] => :running
    end

    event :passed do
      transition :running => :passing
    end

    event :failed do
      transition :running => :failing
    end

    event :publish do
      transition :passing => :published
    end

    after_transition any => :running do |report, transition|
      unless report.member.get_ec2_instance.try(:state).to_s == 'running'
        Pusher["report_#{report.id}"].trigger('booting', 'booting')
        report.member.create_ec2_instance!
      end
      Pusher["report_#{report.id}"].trigger('running', 'running')
      report.update_attribute :output, nil
      report.member.update_attribute :ec2_last_accessed_at, Time.now
      ec2_instance = report.member.get_ec2_instance
      local_script_name = Tempfile.new report.member.nickname + 'script'
      remote_script_name = local_script_name.path.split('/').last
      File.open(local_script_name, 'w') {|f| f.write(report.code + "\n")}
      ec2_instance.scp_upload(local_script_name, remote_script_name)
      local_script_name.delete
      output = ec2_instance.ssh("R < #{remote_script_name} --vanilla")[0].stdout.strip
      output = output.slice(output.index('>')..-1) if output.index('>').to_i > 0
      report.update_attribute :output, output      
      if output.include?('Execution halted')
        report.failed! 
        Pusher["report_#{report.id}"].trigger('failed', 'failed')
      else
        report.passed!
        Pusher["report_#{report.id}"].trigger('passed', 'passed')
        Pusher["report_#{report.id}"].trigger('retrieving_plots', 'Retrieving plots...')
        ec2_instance.ssh("convert -density 300 -resize 1000x1000\> -quality 100 Rplots.pdf Rplots.png")
        (0..1000).each do |i|
          begin
            remote_page_name = "Rplots-#{i}.png"
            local_page_name = Tempfile.new report.member.nickname + remote_page_name
            if i == 0
              begin
                ec2_instance.scp_download remote_page_name, local_page_name.path
              rescue Net::SCP::Error
                remote_page_name = "Rplots.png"
                ec2_instance.scp_download remote_page_name, local_page_name.path
              end
            else
              ec2_instance.scp_download remote_page_name, local_page_name.path
            end
            if plot=report.plots.find_by_position(i + 1)
              plot.update_attributes :plot => local_page_name
            else
              report.plots.create :plot => local_page_name, :report_id => report.id, :position => (i + 1)
            end
            local_page_name.delete 
            ec2_instance.ssh "rm #{remote_page_name}"
            Pusher["report_#{report.id}"].trigger('retrieving_plots', "Retrieved plot #{i + 1}...")
          rescue Net::SCP::Error
            report.plots.where('position >= ?', i + 1).destroy_all
            break 
          end
        end
      end
      ec2_instance.ssh "rm Rplots.pdf"
      Pusher["report_#{report.id}"].trigger('finished', report.state)
    end
    
    after_transition any => :published do |report, transition|
      report.member.member_followers.each {|m| m.delay.notify!(report, "#{report.member.nickname}'s published a report")}
      report.member.delay.notify!(report, "Your report was published")
    end
  end
  
  def state_human
    case state
      when 'pending' then 'Pending'
      when 'preparing_to_run' then 'Preparing to run'
      when 'running' then 'Running'
      when 'passing' then 'Passing'
      when 'failing' then 'Failing'
      when 'published' then 'Published'
    end
  end

  def forkit!(member_id)
    Report.transaction do 
      new_report = self.dup
      new_report.forked_from = self
      new_report.member_id = member_id 
      new_report.state = 'pending'
      new_report.output = nil
      new_report.tag_list = tag_list
      new_report.save!
      return new_report
    end
  end
  
  protected
    
    def init_code
      if code.blank?
        self.code = "# Your code goes here\n\nhello_world <- function(arg1) {\n  print(arg1)\n}\n\nhello_world('hello world');"
      end
    end
  
    def set_survey_references
      code.to_s.scan(/#{ENV['domain']}\/surveys\/([[a-z][A-Z][0-9]\-]+)/) do |slug|
        if (survey_referenced = Survey.find_by_slug(slug))
          surveys << survey_referenced
        end
      end
    end
end
