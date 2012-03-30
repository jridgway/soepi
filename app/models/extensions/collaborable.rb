module Extensions
  module Collaborable   
    extend ActiveSupport::Concern
    
    included do
      has_many :collaborators, :as => :collaborable, :dependent => :destroy
    end
       
    module InstanceMethods      
      def collaborator_ids
        collaborators.collect(&:member_id).join(',')
      end
      
      def collaborator_ids_a
        collaborators.collect(&:member_id)
      end
    end
  end
end

