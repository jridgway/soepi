class Version < ActiveRecord::Base
  belongs_to :versionable, :polymorphic => true
  belongs_to :member
      
  def compare(version_b)
    Diffy::Diff.new(versionable.class.new.load_version(version_b).for_diff, 
      versionable.class.new.load_version(self).for_diff)
  end
  
  def name
    "Version #{position} by #{member.nickname} on #{updated_at.strftime('%b %d %Y at %I:%M %p')}"
  end
end
