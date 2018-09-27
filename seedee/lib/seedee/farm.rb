# frozen_string_literal: true

require 'securerandom'

module Seedee
  class Farm
    def startup_all
      startup_clients
      startup_restbus
      startup_ttc_notices
      startup_load_balancer
    end

    def startup_clients
      type = 'client'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::client]'
      ]

      DigitalOcean.new.destroy_droplets(['transit-tips', type])
      startup(type, recipes)
    end

    def startup_restbus
      type = 'restbus'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::restbus]'
      ]

      DigitalOcean.new.destroy_droplets(['transit-tips', type])
      startup(type, recipes)
    end

    def startup_ttc_notices
      type = 'ttc-notices'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::ttc_notices]'
      ]

      DigitalOcean.new.destroy_droplets(['transit-tips', type])
      startup(type, recipes)
    end

    def startup_load_balancer
      type = 'load-balancer'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::load_balancer]'
      ]

      DigitalOcean.new.destroy_droplets(['transit-tips', type])
      startup(type, recipes)
    end

    private

    def privision(droplet, type, recipes = [], description)
      result = provisioner.bootstrap(droplet.public_ip)
    end

    def destroy_nodes(tags)
      cloud_provider = DigitalOcean.new
      cloud_provider.destroy_droplets(tags)
    end

    def startup(type, recipes = [], description = '')
      droplet_id = nil
      type = type.to_s.strip
      recipes = Array(recipes).map(&:to_s).map(&:strip)
      description = description.to_s.strip
      provisioner = Chef.new(type, recipes, description)
      cloud_provider = DigitalOcean.new

      puts "creating role #{type}"
      role = provisioner.create_role

      name = provisioner.node_name
      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name, ['transit-tips', type])
      droplet_id = droplet.id

      # wait 20 seconds for droplet to be available
      sleep(20)

      puts "Boostrapping node #{name} with ip #{droplet.public_ip} " \
        "having droplet attributes #{droplet.as_json}"

      result = provisioner.bootstrap(droplet.public_ip)
      raise 'knife bootstrap failed to execute' if result.nil?
      raise 'knife bootstrap returned 1' if result == false
    rescue => exception
      puts exception
      cloud_provider.destroy_droplet(droplet_id)
      provisioner.delete_node
    ensure
      # TODO: move it outside of the function if want to bootstrap 
      # multiple nodes
      # puts 'deleting nodes and role'
      # provisioner.delete_role_and_associated_nodes
      # cloud_provider.
    end
  end
end
