class Report < ActiveRecord::Base
  belongs_to :member
  belongs_to :r_script
  has_many :plots, :class_name => 'ReportPlot'
  has_and_belongs_to_many :surveys
  
  accepts_nested_attributes_for :plots

  acts_as_taggable
  acts_as_followable
  
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates :title, :presence => true, :uniqueness => true
  validates :r_script_id, :member_id, :presence => true
  
  default_scope order('created_at desc')
  scope :drafting, where(:state => 'drafting')
  scope :published, where(:state => 'published')

  def posted_by
    member.nickname if member
  end
  
  def human 
    title
  end
  
  searchable do
    text :title
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
    string :state
    integer :id
  end
  
  state_machine :state, :initial => :pending do
    state :pending
    state :drafting
    state :published    

    event :run do
      transition :pending => :drafting
    end

    event :publish do
      transition :drafting => :published
    end

    after_transition any => :drafting do |report, transition|
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
      if report.member_id == report.r_script.member_id
        if output.include?('Execution halted')
          report.r_script.failed! 
        else
          report.r_script.passed!
        end
      end
      ec2_instance.ssh("convert -density 300 -resize 1000x1000\> -quality 100 Rplots.pdf Rplots.png")
      (0..1000).each do |i|
        begin
          remote_page_name = "Rplots-#{i}.png"
          local_page_name = Tempfile.new report.member.nickname + remote_page_name
          ec2_instance.scp_download remote_page_name, local_page_name.path
          report.plots.create :plot => local_page_name, :report_id => report.id, :position => (i + 1)
          local_page_name.delete 
          ec2_instance.ssh "rm #{remote_page_name}"
        rescue Net::SCP::Error
          break 
        end
      end
      ec2_instance.ssh "rm Rplots.pdf"
    end
  end
  
  def state_human
    case state
      when 'drafting' then 'Drafting'
      when 'published' then 'Published'
    end
  end
end
