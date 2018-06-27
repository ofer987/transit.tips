# frozen_string_literal: true

require 'securerandom'

module Seedee
  # The servers in the Digital Ocean farm
  class Farm
    def provision_client_node
      name = "client-#{SecureRandom.uuid}"

      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name)

      puts "Boostraping node #{name} with ip #{droplet.public_ip} having droplet attributes #{droplet.as_json}"
      provisioner.bootstrap(droplet, name, 'transit.tips::client')
    end

    private

    def cloud_provider
      @cloud_provider ||= DigitalOcean.new
    end

    def provisioner
      @provisioner ||= Chef.new
    end
  end
end
