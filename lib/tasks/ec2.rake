desc "Make sure EC2 instances don't stay up for more than 10 minutes of inactivity and remove orphan servers with an image_id of ami-29ff3440"
task :terminte_inactive_ec2_instances => :environment do
  Member.where('ec2_instance_id is not null').each do |member|
    if member.ec2_last_accessed_at < 1.hour.ago or member.get_ec2_instance.nil?
      member.destroy_ec2_instance!
    end
  end
  
  connection = Fog::Compute.new(
      :provider => 'AWS', 
      :aws_secret_access_key => ENV['S3_SECRET'], 
      :aws_access_key_id => ENV['S3_KEY']
    )
    
  connection.servers.each do |server|
    if server.image_id == 'ami-29ff3440' and server.try(:state).to_s == 'running' and not Member.find_by_ec2_instance_id(server.id)
      server.destroy
    end  
  end
end