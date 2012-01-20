class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  
  default_scope order('created_at asc')
  
  image_accessor :file
end
