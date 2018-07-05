# frozen_string_literal: true

require 'securerandom'

module Seedee
  # The servers in the Digital Ocean farm
  class Farm
    def provision_client_node
      name = "client-#{SecureRandom.uuid}"

      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name)

      # wait 20 seconds for droplet to be available
      sleep(20)
      bootstrap(name, droplet)
    end

    private

    def bootstrap(name, droplet)
      puts "Boostraping node #{name} with ip #{droplet.public_ip} " \
        "having droplet attributes #{droplet.as_json}"

      result = provisioner.bootstrap(droplet, name, 'transit.tips::client')
      raise 'knife bootstrap failed to execute' if result.nil?
      raise 'knife bootstrap returned 1' if result == false
    rescue => exception
      puts exception
      cloud_provider.destroy_droplet(droplet.id)
    end

    def cloud_provider
      @cloud_provider ||= DigitalOcean.new
    end

    def provisioner
      @provisioner ||= Chef.new
    end
  end
end
