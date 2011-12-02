desc "Make sure EC2 instances don't stay up for more than 10 minutes of inactivity"
task :terminte_inactive_ec2_instances => :environment do
  Member.where('ec2_instance_id is not null').each do |member|
    if member.ec2_last_accessed_at < 1.hour.ago or member.get_ec2_instance.nil?
      member.destroy_ec2_instance!
    end
  end
end