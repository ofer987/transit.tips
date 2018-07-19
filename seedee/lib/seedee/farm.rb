# frozen_string_literal: true

require 'securerandom'

module Seedee
  # The servers in the Digital Ocean farm
  class Farm
    def provision_client_node
      role_name = "client-#{SecureRandom.uuid}"
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::client]'
      ]

      puts "creating role #{role_name}"
      role = provisioner.create_role(role_name, recipes)

      name = "client-#{SecureRandom.uuid}"
      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name)

      # wait 20 seconds for droplet to be available
      sleep(20)

      bootstrap(name, role_name, droplet)
      provisioner.delete_role_and_associated_nodes('client*', [role_name])
    end

    private

    def bootstrap(name, role_name, droplet)
      puts "Boostraping node #{name} with ip #{droplet.public_ip} " \
        "having droplet attributes #{droplet.as_json}"

      result = provisioner.bootstrap(droplet, name, [role_name])
      raise 'knife bootstrap failed to execute' if result.nil?
      raise 'knife bootstrap returned 1' if result == false
    rescue => exception
      puts exception
      cloud_provider.destroy_droplet(droplet.id)

      # Exit the script with failure status code
      raise
    end

    def cloud_provider
      @cloud_provider ||= DigitalOcean.new
    end

    def provisioner
      @provisioner ||= Chef.new
    end
  end
end
