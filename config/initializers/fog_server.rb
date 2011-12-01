require 'fog/core/model'

module Fog
  module Compute
    class Server < Fog::Model

      def scp_upload(local_path, remote_path, upload_options = {})
        require 'net/scp'
        requires :public_ip_address, :username

        scp_options = {}
        scp_options[:key_data] = [private_key] if private_key
        Fog::SCP.new(public_ip_address, username, scp_options).upload(local_path, remote_path, upload_options)
      end

      def scp_download(remote_path, local_path, upload_options = {})
        require 'net/scp'
        requires :public_ip_address, :username

        scp_options = {}
        scp_options[:key_data] = [private_key] if private_key
        Fog::SCP.new(public_ip_address, username, scp_options).download(remote_path, local_path, upload_options)
      end

      def ssh(commands)
        require 'net/ssh'
        requires :public_ip_address, :username

        options = {}
        options[:key_data] = [private_key] if private_key
        Fog::SSH.new(public_ip_address, username, options).run(commands)
      end

    end
  end
end
