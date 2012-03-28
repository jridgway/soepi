module Extensions
  module Versionable   
    extend ActiveSupport::Concern
    
    included do
      has_many :versions, :as => :versionable, :dependent => :destroy, :order => 'position desc' do 
        def current 
          where(:current => true).first
        end
      end
    end
       
    module InstanceMethods
      def version!(member_id)
        if current_version and current_version.member_id == member_id and 
        current_version.updated_at >= 10.minutes.ago and current_version.position == versions.count
          update_version!(current_version)
        else
          create_version!(member_id)
        end
      end
      
      def current_version
        versions.where(:current => true).first
      end
      
      def revert_to_version!(version_id)
        Version.transaction do 
          previous_version = current_version
          version = versions.find(version_id)
          load_version(version)
          save!
          version.update_attribute :current, true
          previous_version.update_attribute :current, false
        end
      end
      
      protected
      
        def update_version!(current_version)
          current_version.update_attribute :data, versionable_dup
          current_version
        end
      
        def create_version!(member_id)
          Version.transaction do 
            versions.update_all :current => false
            version = versions.create :data => versionable_dup, :member_id => member_id, 
              :current => true, :position => (versions.count + 1)
            return version
          end
        end
        
        def versionable_dup
          reload
          d = dup
          d.created_at = created_at
          d.updated_at = updated_at
          Base64.encode64(Marshal.dump(d))
        end
    end
  end
end

