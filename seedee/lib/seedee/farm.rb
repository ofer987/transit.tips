# frozen_string_literal: true

require 'securerandom'

module Seedee
  class Farm
    def startup_all
      startup_clients
      startup_restbus
    end

    def startup_clients
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::client]'
      ]

      startup('client', recipes)
    end

    def startup_restbus
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::restbus]'
      ]

      startup('restbus', recipes)
    end

    private

    def startup(type, recipes = [], description = '')
      type = type.to_s.strip
      recipes = Array(recipes).map(&:to_s).map(&:strip)
      description = description.to_s.strip
      provisioner = Chef.new(type, recipes, description)
      cloud_provider = DigitalOcean.new

      puts "creating role #{role_name}"
      role = provisioner.create_role

      name = "#{type}-#{SecureRandom.uuid}"
      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name)

      # wait 20 seconds for droplet to be available
      sleep(20)

      puts "Boostraping node #{name} with ip #{droplet.public_ip} " \
        "having droplet attributes #{droplet.as_json}"

      result = provisioner.bootstrap(name, droplet.public_ip)
      raise 'knife bootstrap failed to execute' if result.nil?
      raise 'knife bootstrap returned 1' if result == false
    rescue => exception
      puts exception
      cloud_provider.destroy_droplet(droplet.id)

      # Exit the script with failure status code
      raise
    ensure
      provisioner.delete_role_and_associated_nodes
    end
  end
end
