# RailsAdmin config file. Generated on February 29, 2012 11:23
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_member } # auto-generated
  
  config.authorize_with do
    unless current_member.admin?
      flash[:notice] = 'Insufficient Permissions'
      redirect_to '/' 
    end
  end

  # If you want to track changes on your models:
  # config.audit_with :history, Member

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, Member

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['SoEpi', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [AgeGroup, Asset, Census, CensusGeo, CensusGeoProfile, Education, Ethnicity, Gender, Member, MemberCreditTransaction, MemberStatus, MemberToken, Message, MessageMember, Notification, Page, Part, Participant, ParticipantResponse, ParticipantSurvey, Race, Region, Report, ReportPlot, Setting, Survey, SurveyDownload, SurveyQuestion, SurveyQuestionChoice, Target]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [AgeGroup, Asset, Census, CensusGeo, CensusGeoProfile, Education, Ethnicity, Gender, Member, MemberCreditTransaction, MemberStatus, MemberToken, Message, MessageMember, Notification, Page, Part, Participant, ParticipantResponse, ParticipantSurvey, Race, Region, Report, ReportPlot, Setting, Survey, SurveyDownload, SurveyQuestion, SurveyQuestionChoice, Target]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model AgeGroup do
  #   # Found associations:
  #     configure :targets, :has_and_belongs_to_many_association 
  #     configure :participant_surveys, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :min, :integer 
  #     configure :max, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Asset do
  #   # Found associations:
  #     configure :assetable, :polymorphic_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :assetable_type, :string 
  #     configure :assetable_id, :integer         # Hidden 
  #     configure :assetable_type, :string         # Hidden 
  #     configure :file, :string 
  #     configure :file_name, :string         # Hidden 
  #     configure :file_uid, :string         # Hidden 
  #     configure :file, :dragonfly 
  #     configure :file_mime_type, :string 
  #     configure :file_size, :integer 
  #     configure :file_width, :integer 
  #     configure :file_height, :string 
  #     configure :file_image_uid, :string 
  #     configure :file_image_ext, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Census do
  #   # Found associations:
  #     configure :geos, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :year, :integer   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model CensusGeo do
  #   # Found associations:
  #     configure :census, :belongs_to_association 
  #     configure :profile, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :census_id, :integer         # Hidden 
  #     configure :fileid, :string 
  #     configure :stusab, :string 
  #     configure :sumlev, :string 
  #     configure :geocomp, :string 
  #     configure :chariter, :string 
  #     configure :cifsn, :string 
  #     configure :region, :string 
  #     configure :division, :string 
  #     configure :state, :string 
  #     configure :county, :string 
  #     configure :countycc, :string 
  #     configure :countysc, :string 
  #     configure :cousub, :string 
  #     configure :cousubcc, :string 
  #     configure :cousubsc, :string 
  #     configure :place, :string 
  #     configure :placecc, :string 
  #     configure :placesc, :string 
  #     configure :tract, :string 
  #     configure :blkgrp, :string 
  #     configure :block, :string 
  #     configure :iuc, :string 
  #     configure :concit, :string 
  #     configure :concitcc, :string 
  #     configure :concitsc, :string 
  #     configure :aianhh, :string 
  #     configure :aianhhfp, :string 
  #     configure :aianhhcc, :string 
  #     configure :aihhtli, :string 
  #     configure :aitsce, :string 
  #     configure :aits, :string 
  #     configure :aitscc, :string 
  #     configure :ttract, :string 
  #     configure :tblkgrp, :string 
  #     configure :anrc, :string 
  #     configure :anrccc, :string 
  #     configure :cbsa, :string 
  #     configure :cbsasc, :string 
  #     configure :metdiv, :string 
  #     configure :csa, :string 
  #     configure :necta, :string 
  #     configure :nectasc, :string 
  #     configure :nectadiv, :string 
  #     configure :cnecta, :string 
  #     configure :cbsapci, :string 
  #     configure :nectapci, :string 
  #     configure :ua, :string 
  #     configure :uasc, :string 
  #     configure :uatype, :string 
  #     configure :ur, :string 
  #     configure :cd, :string 
  #     configure :sldu, :string 
  #     configure :sldl, :string 
  #     configure :vtd, :string 
  #     configure :vtdi, :string 
  #     configure :reserve2, :string 
  #     configure :zcta5, :string 
  #     configure :submcd, :string 
  #     configure :submcdcc, :string 
  #     configure :sdelm, :string 
  #     configure :sdsec, :string 
  #     configure :sduni, :string 
  #     configure :arealand, :string 
  #     configure :areawatr, :string 
  #     configure :name, :string 
  #     configure :funcstat, :string 
  #     configure :gcuni, :string 
  #     configure :pop100, :string 
  #     configure :hu100, :string 
  #     configure :intptlat, :string 
  #     configure :intptlon, :string 
  #     configure :lsadc, :string 
  #     configure :partflag, :string 
  #     configure :reserve3, :string 
  #     configure :uga, :string 
  #     configure :statens, :string 
  #     configure :countyns, :string 
  #     configure :cousubns, :string 
  #     configure :placens, :string 
  #     configure :concitns, :string 
  #     configure :aianhhns, :string 
  #     configure :aitsns, :string 
  #     configure :anrcns, :string 
  #     configure :submcdns, :string 
  #     configure :cd113, :string 
  #     configure :cd114, :string 
  #     configure :cd115, :string 
  #     configure :sldu2, :string 
  #     configure :sldu3, :string 
  #     configure :sldu4, :string 
  #     configure :sldl2, :string 
  #     configure :sldl3, :string 
  #     configure :sldl4, :string 
  #     configure :aianhhsc, :string 
  #     configure :csasc, :string 
  #     configure :cnectasc, :string 
  #     configure :memi, :string 
  #     configure :nmemi, :string 
  #     configure :puma, :string 
  #     configure :reserved, :string 
  #     configure :logrecno, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model CensusGeoProfile do
  #   # Found associations:
  #     configure :geo, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :fileid, :string 
  #     configure :stusab, :string 
  #     configure :chariter, :string 
  #     configure :cifsn, :string 
  #     configure :dpsf0010001, :decimal 
  #     configure :dpsf0010002, :decimal 
  #     configure :dpsf0010003, :decimal 
  #     configure :dpsf0010004, :decimal 
  #     configure :dpsf0010005, :decimal 
  #     configure :dpsf0010006, :decimal 
  #     configure :dpsf0010007, :decimal 
  #     configure :dpsf0010008, :decimal 
  #     configure :dpsf0010009, :decimal 
  #     configure :dpsf0010010, :decimal 
  #     configure :dpsf0010011, :decimal 
  #     configure :dpsf0010012, :decimal 
  #     configure :dpsf0010013, :decimal 
  #     configure :dpsf0010014, :decimal 
  #     configure :dpsf0010015, :decimal 
  #     configure :dpsf0010016, :decimal 
  #     configure :dpsf0010017, :decimal 
  #     configure :dpsf0010018, :decimal 
  #     configure :dpsf0010019, :decimal 
  #     configure :dpsf0010020, :decimal 
  #     configure :dpsf0010021, :decimal 
  #     configure :dpsf0010022, :decimal 
  #     configure :dpsf0010023, :decimal 
  #     configure :dpsf0010024, :decimal 
  #     configure :dpsf0010025, :decimal 
  #     configure :dpsf0010026, :decimal 
  #     configure :dpsf0010027, :decimal 
  #     configure :dpsf0010028, :decimal 
  #     configure :dpsf0010029, :decimal 
  #     configure :dpsf0010030, :decimal 
  #     configure :dpsf0010031, :decimal 
  #     configure :dpsf0010032, :decimal 
  #     configure :dpsf0010033, :decimal 
  #     configure :dpsf0010034, :decimal 
  #     configure :dpsf0010035, :decimal 
  #     configure :dpsf0010036, :decimal 
  #     configure :dpsf0010037, :decimal 
  #     configure :dpsf0010038, :decimal 
  #     configure :dpsf0010039, :decimal 
  #     configure :dpsf0010040, :decimal 
  #     configure :dpsf0010041, :decimal 
  #     configure :dpsf0010042, :decimal 
  #     configure :dpsf0010043, :decimal 
  #     configure :dpsf0010044, :decimal 
  #     configure :dpsf0010045, :decimal 
  #     configure :dpsf0010046, :decimal 
  #     configure :dpsf0010047, :decimal 
  #     configure :dpsf0010048, :decimal 
  #     configure :dpsf0010049, :decimal 
  #     configure :dpsf0010050, :decimal 
  #     configure :dpsf0010051, :decimal 
  #     configure :dpsf0010052, :decimal 
  #     configure :dpsf0010053, :decimal 
  #     configure :dpsf0010054, :decimal 
  #     configure :dpsf0010055, :decimal 
  #     configure :dpsf0010056, :decimal 
  #     configure :dpsf0010057, :decimal 
  #     configure :dpsf0020001, :decimal 
  #     configure :dpsf0020002, :decimal 
  #     configure :dpsf0020003, :decimal 
  #     configure :dpsf0030001, :decimal 
  #     configure :dpsf0030002, :decimal 
  #     configure :dpsf0030003, :decimal 
  #     configure :dpsf0040001, :decimal 
  #     configure :dpsf0040002, :decimal 
  #     configure :dpsf0040003, :decimal 
  #     configure :dpsf0050001, :decimal 
  #     configure :dpsf0050002, :decimal 
  #     configure :dpsf0050003, :decimal 
  #     configure :dpsf0060001, :decimal 
  #     configure :dpsf0060002, :decimal 
  #     configure :dpsf0060003, :decimal 
  #     configure :dpsf0070001, :decimal 
  #     configure :dpsf0070002, :decimal 
  #     configure :dpsf0070003, :decimal 
  #     configure :dpsf0080001, :decimal 
  #     configure :dpsf0080002, :decimal 
  #     configure :dpsf0080003, :decimal 
  #     configure :dpsf0080004, :decimal 
  #     configure :dpsf0080005, :decimal 
  #     configure :dpsf0080006, :decimal 
  #     configure :dpsf0080007, :decimal 
  #     configure :dpsf0080008, :decimal 
  #     configure :dpsf0080009, :decimal 
  #     configure :dpsf0080010, :decimal 
  #     configure :dpsf0080011, :decimal 
  #     configure :dpsf0080012, :decimal 
  #     configure :dpsf0080013, :decimal 
  #     configure :dpsf0080014, :decimal 
  #     configure :dpsf0080015, :decimal 
  #     configure :dpsf0080016, :decimal 
  #     configure :dpsf0080017, :decimal 
  #     configure :dpsf0080018, :decimal 
  #     configure :dpsf0080019, :decimal 
  #     configure :dpsf0080020, :decimal 
  #     configure :dpsf0080021, :decimal 
  #     configure :dpsf0080022, :decimal 
  #     configure :dpsf0080023, :decimal 
  #     configure :dpsf0080024, :decimal 
  #     configure :dpsf0090001, :decimal 
  #     configure :dpsf0090002, :decimal 
  #     configure :dpsf0090003, :decimal 
  #     configure :dpsf0090004, :decimal 
  #     configure :dpsf0090005, :decimal 
  #     configure :dpsf0090006, :decimal 
  #     configure :dpsf0100001, :decimal 
  #     configure :dpsf0100002, :decimal 
  #     configure :dpsf0100003, :decimal 
  #     configure :dpsf0100004, :decimal 
  #     configure :dpsf0100005, :decimal 
  #     configure :dpsf0100006, :decimal 
  #     configure :dpsf0100007, :decimal 
  #     configure :dpsf0110001, :decimal 
  #     configure :dpsf0110002, :decimal 
  #     configure :dpsf0110003, :decimal 
  #     configure :dpsf0110004, :decimal 
  #     configure :dpsf0110005, :decimal 
  #     configure :dpsf0110006, :decimal 
  #     configure :dpsf0110007, :decimal 
  #     configure :dpsf0110008, :decimal 
  #     configure :dpsf0110009, :decimal 
  #     configure :dpsf0110010, :decimal 
  #     configure :dpsf0110011, :decimal 
  #     configure :dpsf0110012, :decimal 
  #     configure :dpsf0110013, :decimal 
  #     configure :dpsf0110014, :decimal 
  #     configure :dpsf0110015, :decimal 
  #     configure :dpsf0110016, :decimal 
  #     configure :dpsf0110017, :decimal 
  #     configure :dpsf0120001, :decimal 
  #     configure :dpsf0120002, :decimal 
  #     configure :dpsf0120003, :decimal 
  #     configure :dpsf0120004, :decimal 
  #     configure :dpsf0120005, :decimal 
  #     configure :dpsf0120006, :decimal 
  #     configure :dpsf0120007, :decimal 
  #     configure :dpsf0120008, :decimal 
  #     configure :dpsf0120009, :decimal 
  #     configure :dpsf0120010, :decimal 
  #     configure :dpsf0120011, :decimal 
  #     configure :dpsf0120012, :decimal 
  #     configure :dpsf0120013, :decimal 
  #     configure :dpsf0120014, :decimal 
  #     configure :dpsf0120015, :decimal 
  #     configure :dpsf0120016, :decimal 
  #     configure :dpsf0120017, :decimal 
  #     configure :dpsf0120018, :decimal 
  #     configure :dpsf0120019, :decimal 
  #     configure :dpsf0120020, :decimal 
  #     configure :dpsf0130001, :decimal 
  #     configure :dpsf0130002, :decimal 
  #     configure :dpsf0130003, :decimal 
  #     configure :dpsf0130004, :decimal 
  #     configure :dpsf0130005, :decimal 
  #     configure :dpsf0130006, :decimal 
  #     configure :dpsf0130007, :decimal 
  #     configure :dpsf0130008, :decimal 
  #     configure :dpsf0130009, :decimal 
  #     configure :dpsf0130010, :decimal 
  #     configure :dpsf0130011, :decimal 
  #     configure :dpsf0130012, :decimal 
  #     configure :dpsf0130013, :decimal 
  #     configure :dpsf0130014, :decimal 
  #     configure :dpsf0130015, :decimal 
  #     configure :dpsf0140001, :decimal 
  #     configure :dpsf0150001, :decimal 
  #     configure :dpsf0160001, :decimal 
  #     configure :dpsf0170001, :decimal 
  #     configure :dpsf0180001, :decimal 
  #     configure :dpsf0180002, :decimal 
  #     configure :dpsf0180003, :decimal 
  #     configure :dpsf0180004, :decimal 
  #     configure :dpsf0180005, :decimal 
  #     configure :dpsf0180006, :decimal 
  #     configure :dpsf0180007, :decimal 
  #     configure :dpsf0180008, :decimal 
  #     configure :dpsf0180009, :decimal 
  #     configure :dpsf0190001, :decimal 
  #     configure :dpsf0200001, :decimal 
  #     configure :dpsf0210001, :decimal 
  #     configure :dpsf0210002, :decimal 
  #     configure :dpsf0210003, :decimal 
  #     configure :dpsf0220001, :decimal 
  #     configure :dpsf0220002, :decimal 
  #     configure :dpsf0230001, :decimal 
  #     configure :dpsf0230002, :decimal 
  #     configure :logrecno, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Education do
  #   # Found associations:
  #     configure :targets, :has_many_association 
  #     configure :members, :has_many_association 
  #     configure :participant_surveys, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :position, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Ethnicity do
  #   # Found associations:
  #     configure :targets, :has_and_belongs_to_many_association 
  #     configure :members, :has_and_belongs_to_many_association 
  #     configure :participant_surveys, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :position, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Gender do
  #   # Found associations:
  #     configure :targets, :has_and_belongs_to_many_association 
  #     configure :members, :has_many_association 
  #     configure :participant_surveys, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :position, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Member do
  #   # Found associations:
  #     configure :tokens, :has_many_association 
  #     configure :surveys, :has_many_association 
  #     configure :reports, :has_many_association 
  #     configure :notifications, :has_many_association 
  #     configure :messages, :has_many_association 
  #     configure :message_members, :has_many_association 
  #     configure :messages_received, :has_many_association 
  #     configure :statuses, :has_many_association 
  #     configure :status_references, :has_and_belongs_to_many_association 
  #     configure :taggings, :has_many_association         # Hidden 
  #     configure :base_tags, :has_many_association         # Hidden 
  #     configure :tag_taggings, :has_many_association         # Hidden 
  #     configure :tags, :has_many_association         # Hidden 
  #     configure :followings, :has_many_association         # Hidden 
  #     configure :follows, :has_many_association         # Hidden   #   # Found columns:
  #     configure :id, :integer 
  #     configure :password_salt, :string         # Hidden 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :remember_created_at, :datetime 
  #     configure :confirmation_token, :string 
  #     configure :confirmed_at, :datetime 
  #     configure :confirmation_sent_at, :datetime 
  #     configure :authentication_token, :string 
  #     configure :failed_attempts, :integer 
  #     configure :unlock_token, :string 
  #     configure :locked_at, :datetime 
  #     configure :nickname, :string 
  #     configure :pic, :string 
  #     configure :pic_name, :string         # Hidden 
  #     configure :pic_uid, :string         # Hidden 
  #     configure :pic, :dragonfly 
  #     configure :pic_mime_type, :string 
  #     configure :pic_size, :integer 
  #     configure :pic_width, :integer 
  #     configure :pic_height, :integer 
  #     configure :pic_image_uid, :string 
  #     configure :pic_image_ext, :string 
  #     configure :language, :string 
  #     configure :informed_consent, :boolean 
  #     configure :terms_of_use, :boolean 
  #     configure :subscription_notifications, :boolean 
  #     configure :subscription_messages, :boolean 
  #     configure :subscription_news, :boolean 
  #     configure :year_registered, :integer 
  #     configure :admin, :boolean 
  #     configure :subscription_charts, :boolean 
  #     configure :privacy_dont_use_my_gravatar, :boolean 
  #     configure :privacy_dont_list_me, :boolean 
  #     configure :slug, :string 
  #     configure :subscription_weekly_summaries, :boolean 
  #     configure :credits, :integer 
  #     configure :ec2_instance_id, :string 
  #     configure :booting_ec2_instance, :boolean 
  #     configure :ec2_last_accessed_at, :datetime 
  #     configure :last_notifications_delivered_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model MemberCreditTransaction do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer 
  #     configure :credits, :integer 
  #     configure :member_id, :integer 
  #     configure :reason, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model MemberStatus do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :member_references, :has_and_belongs_to_many_association 
  #     configure :notifications, :has_many_association 
  #     configure :taggings, :has_many_association         # Hidden 
  #     configure :base_tags, :has_many_association         # Hidden 
  #     configure :tag_taggings, :has_many_association         # Hidden 
  #     configure :tags, :has_many_association         # Hidden   #   # Found columns:
  #     configure :id, :integer 
  #     configure :body, :text 
  #     configure :repost_id, :integer 
  #     configure :member_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model MemberToken do
  #   # Found associations:
  #     configure :member, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :member_id, :integer         # Hidden 
  #     configure :provider, :string 
  #     configure :uid, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Message do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :message_members, :belongs_to_association 
  #     configure :members, :has_many_association 
  #     configure :responses, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :member_id, :integer         # Hidden 
  #     configure :body, :text 
  #     configure :message_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model MessageMember do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :message, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :member_id, :integer         # Hidden 
  #     configure :message_id, :integer         # Hidden 
  #     configure :seen, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Notification do
  #   # Found associations:
  #     configure :notifiable, :polymorphic_association 
  #     configure :member, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :notifiable_id, :integer         # Hidden 
  #     configure :notifiable_type, :string         # Hidden 
  #     configure :message, :string 
  #     configure :member_id, :integer         # Hidden 
  #     configure :seen, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Page do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :assets, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :title, :string 
  #     configure :body, :text 
  #     configure :css, :text 
  #     configure :javascript, :text 
  #     configure :browser_title, :string 
  #     configure :custom_title, :string 
  #     configure :use_custom_title, :boolean 
  #     configure :meta_keywords, :string 
  #     configure :meta_description, :string 
  #     configure :redirect_url, :string 
  #     configure :state, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :slug, :string 
  #     configure :raw, :boolean 
  #     configure :member_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Part do
  #   # Found associations:
  #     configure :assets, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :body, :text 
  #     configure :url_regex, :string 
  #     configure :css, :text 
  #     configure :javascript, :text 
  #     configure :show_at, :datetime 
  #     configure :hide_at, :datetime 
  #     configure :state, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :raw, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Participant do
  #   # Found associations:
  #     configure :gender, :belongs_to_association 
  #     configure :education, :belongs_to_association 
  #     configure :responses, :has_many_association 
  #     configure :surveys, :has_many_association 
  #     configure :ethnicities, :has_and_belongs_to_many_association 
  #     configure :races, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :anonymous_key, :string 
  #     configure :gender_id, :integer         # Hidden 
  #     configure :education_id, :integer         # Hidden 
  #     configure :birthmonth, :date 
  #     configure :city, :string 
  #     configure :state, :string 
  #     configure :postal_code, :string 
  #     configure :country, :string 
  #     configure :lat, :float 
  #     configure :lng, :float   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model ParticipantResponse do
  #   # Found associations:
  #     configure :participant, :belongs_to_association 
  #     configure :question, :belongs_to_association 
  #     configure :single_choice, :belongs_to_association 
  #     configure :participant_survey, :belongs_to_association 
  #     configure :multiple_choices, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :participant_id, :integer         # Hidden 
  #     configure :question_id, :integer         # Hidden 
  #     configure :numeric_response, :integer 
  #     configure :datetime_response, :datetime 
  #     configure :text_response, :text 
  #     configure :created_at, :date 
  #     configure :single_choice_id, :integer         # Hidden 
  #     configure :participant_survey_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model ParticipantSurvey do
  #   # Found associations:
  #     configure :participant, :belongs_to_association 
  #     configure :survey, :belongs_to_association 
  #     configure :gender, :belongs_to_association 
  #     configure :education, :belongs_to_association 
  #     configure :next_question, :belongs_to_association 
  #     configure :age_group, :belongs_to_association 
  #     configure :region, :belongs_to_association 
  #     configure :ethnicities, :has_and_belongs_to_many_association 
  #     configure :races, :has_and_belongs_to_many_association 
  #     configure :responses, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :participant_id, :integer         # Hidden 
  #     configure :survey_id, :integer         # Hidden 
  #     configure :gender_id, :integer         # Hidden 
  #     configure :education_id, :integer         # Hidden 
  #     configure :city, :string 
  #     configure :state, :string 
  #     configure :postal_code, :string 
  #     configure :country, :string 
  #     configure :created_at, :date 
  #     configure :next_question_id, :integer         # Hidden 
  #     configure :complete, :boolean 
  #     configure :age_group_id, :integer         # Hidden 
  #     configure :region_id, :integer         # Hidden 
  #     configure :lat, :float 
  #     configure :lng, :float 
  #     configure :weight, :float   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Race do
  #   # Found associations:
  #     configure :targets, :has_and_belongs_to_many_association 
  #     configure :members, :has_and_belongs_to_many_association 
  #     configure :participant_surveys, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :position, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Region do
  #   # Found associations:
  #     configure :targets, :has_and_belongs_to_many_association 
  #     configure :participant_surveys, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :label, :string 
  #     configure :position, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Report do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :forked_from, :belongs_to_association 
  #     configure :job, :belongs_to_association         # Hidden 
  #     configure :plots, :has_many_association 
  #     configure :forks, :has_many_association 
  #     configure :surveys, :has_and_belongs_to_many_association 
  #     configure :taggings, :has_many_association         # Hidden 
  #     configure :base_tags, :has_many_association         # Hidden 
  #     configure :tag_taggings, :has_many_association         # Hidden 
  #     configure :tags, :has_many_association         # Hidden 
  #     configure :followings, :has_many_association         # Hidden 
  #     configure :follows, :has_many_association         # Hidden   #   # Found columns:
  #     configure :id, :integer 
  #     configure :member_id, :integer         # Hidden 
  #     configure :title, :string 
  #     configure :introduction, :text 
  #     configure :state, :string 
  #     configure :slug, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :code, :text 
  #     configure :output, :text 
  #     configure :conclusion, :text 
  #     configure :forked_from_id, :integer         # Hidden 
  #     configure :job_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model ReportPlot do
  #   # Found associations:
  #     configure :report, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :report_id, :integer         # Hidden 
  #     configure :description, :text 
  #     configure :position, :integer 
  #     configure :plot, :string 
  #     configure :plot_name, :string         # Hidden 
  #     configure :plot_uid, :string         # Hidden 
  #     configure :plot, :dragonfly 
  #     configure :plot_mime_type, :string 
  #     configure :plot_size, :integer 
  #     configure :plot_width, :integer 
  #     configure :plot_height, :integer 
  #     configure :plot_image_uid, :string 
  #     configure :plot_image_ext, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Setting do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :value, :text 
  #     configure :content_type, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Survey do
  #   # Found associations:
  #     configure :member, :belongs_to_association 
  #     configure :forks, :belongs_to_association 
  #     configure :participants, :has_many_association 
  #     configure :questions, :has_many_association 
  #     configure :target, :has_one_association 
  #     configure :notifications, :has_many_association 
  #     configure :downloads, :has_many_association 
  #     configure :reports, :has_and_belongs_to_many_association 
  #     configure :taggings, :has_many_association         # Hidden 
  #     configure :base_tags, :has_many_association         # Hidden 
  #     configure :tag_taggings, :has_many_association         # Hidden 
  #     configure :tags, :has_many_association         # Hidden 
  #     configure :followings, :has_many_association         # Hidden 
  #     configure :follows, :has_many_association         # Hidden   #   # Found columns:
  #     configure :id, :integer 
  #     configure :title, :string 
  #     configure :description, :text 
  #     configure :member_id, :integer         # Hidden 
  #     configure :anonymous, :boolean 
  #     configure :published_at, :datetime 
  #     configure :closed_at, :datetime 
  #     configure :state, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :organization, :boolean 
  #     configure :organization_name, :string 
  #     configure :organization_phone, :string 
  #     configure :organization_email, :string 
  #     configure :purpose_of_survey, :text 
  #     configure :uses_of_results, :text 
  #     configure :time_required_in_minutes, :integer 
  #     configure :cohort, :boolean 
  #     configure :cohort_interval_in_days, :float 
  #     configure :cohort_range_in_days, :float 
  #     configure :irb, :boolean 
  #     configure :irb_name, :string 
  #     configure :irb_phone, :string 
  #     configure :irb_email, :string 
  #     configure :forked_from_id, :integer         # Hidden 
  #     configure :slug, :string 
  #     configure :review_completed_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model SurveyDownload do
  #   # Found associations:
  #     configure :survey, :belongs_to_association 
  #     configure :question, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :survey_id, :integer         # Hidden 
  #     configure :title, :string 
  #     configure :dtype, :string 
  #     configure :position, :integer 
  #     configure :asset, :string 
  #     configure :asset_name, :string         # Hidden 
  #     configure :asset_uid, :string         # Hidden 
  #     configure :asset, :dragonfly 
  #     configure :asset_mime_type, :string 
  #     configure :asset_size, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :question_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model SurveyQuestion do
  #   # Found associations:
  #     configure :survey, :belongs_to_association 
  #     configure :parent_choice, :belongs_to_association 
  #     configure :choices, :has_many_association 
  #     configure :responses, :has_many_association 
  #     configure :survey_downloads, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :survey_id, :integer         # Hidden 
  #     configure :body, :text 
  #     configure :qtype, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :position, :integer 
  #     configure :required, :boolean 
  #     configure :survey_question_choice_id, :integer         # Hidden 
  #     configure :label, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model SurveyQuestionChoice do
  #   # Found associations:
  #     configure :question, :belongs_to_association 
  #     configure :multiple_responses, :has_and_belongs_to_many_association 
  #     configure :single_responses, :has_many_association 
  #     configure :child_questions, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :survey_question_id, :integer         # Hidden 
  #     configure :label, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :position, :integer 
  #     configure :value, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Target do
  #   # Found associations:
  #     configure :targetable, :polymorphic_association 
  #     configure :surveys, :has_and_belongs_to_many_association 
  #     configure :regions, :has_and_belongs_to_many_association 
  #     configure :age_groups, :has_and_belongs_to_many_association 
  #     configure :genders, :has_and_belongs_to_many_association 
  #     configure :ethnicities, :has_and_belongs_to_many_association 
  #     configure :races, :has_and_belongs_to_many_association 
  #     configure :educations, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :target_by_location, :boolean 
  #     configure :city, :string 
  #     configure :country, :string 
  #     configure :radius, :float 
  #     configure :lat, :float 
  #     configure :lng, :float 
  #     configure :approximate_address, :string 
  #     configure :target_by_age_group, :boolean 
  #     configure :target_by_gender, :boolean 
  #     configure :target_by_education, :boolean 
  #     configure :target_by_ethnicity, :boolean 
  #     configure :target_by_race, :boolean 
  #     configure :target_by_survey, :boolean 
  #     configure :targetable_id, :integer         # Hidden 
  #     configure :targetable_type, :string         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :state, :string 
  #     configure :location_type, :string 
  #     configure :require_all_surveys, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
