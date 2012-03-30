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
      
      def revert_to_version!(version_id, member_2)
        Version.transaction do 
          previous_version = current_version
          version = versions.find(version_id)
          load_version(version)
          save!
          version.update_attribute :current, true
          previous_version.update_attribute :current, false
          members_to_notifiy = collaborators.select {|c| c.member_id != member_2.id}.collect(&:member).compact
          if member_2.id != member_id
            members_to_notifiy << member
          end 
          members_to_notifiy.each {|m| m.delay.notify!(self, "#{member_2.nickname} reverted to version #{version.position}")}
        end
      end
      
      def collaborator_ids
        collaborators.collect(&:member_id).join(',')
      end
      
      def collaborator_ids_a
        collaborators.collect(&:member_id)
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

