# frozen_string_literal: true

require 'securerandom'

module Seedee
  class Farm
    attr_reader :type, :recipes, :description, :count

    def self.create_base_image
      type = 'base-image'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[base_image::default]'
      ]
      count = 1
      description = ''

      instance = new(type, recipes, count, description)
      instance.destroy
      instance.startup
    end

    def self.startup_all
      startup_clients
      startup_restbus
      startup_ttc_notices
      startup_load_balancer
    end

    def self.startup_clients
      type = 'client'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::client]'
      ]
      count = 1
      description = ''

      instance = new(type, recipes, count, description)
      instance.destroy
      instance.startup
    end

    def self.startup_restbus
      type = 'restbus'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::restbus]'
      ]
      count = 1
      description = ''

      instance = new(type, recipes, count, description)
      instance.destroy
      instance.startup
    end

    def self.startup_ttc_notices
      type = 'ttc-notices'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::ttc_notices]'
      ]
      count = 1
      description = ''

      instance = new(type, recipes, count, description)
      instance.destroy
      instance.startup
    end

    def self.startup_load_balancer
      type = 'load-balancer'
      recipes = [
        'recipe[chef-client::default]',
        'recipe[chef-client::delete_validation]',
        'recipe[transit.tips::load_balancer]'
      ]
      count = 1
      description = ''

      instance = new(type, recipes, count, description)
      instance.destroy
      instance.startup
    end

    def initialize(type, recipes, description = '', count = 1)
      self.type = type.to_s
      self.recipes = Array(recipes).map(&:to_s).map(&:strip)
      self.description = description.to_s.strip
      self.count = count.to_i
    end

    def destroy
      begin
        cloud_provider.destroy_droplets_for_tags(['transit-tips', self.type])
      rescue => exception
        puts "error droplets with tags = 'transit-tips', '#{self.type}'"
        puts exception.backtrace
        puts exception
      end

      begin
        provisioner.delete_role
      rescue => exception
        puts "error deleting role = #{type}"
        puts exception.backtrace
        puts exception
      end

      provisioner.get_nodes_for_role.each do |node|
        begin
          puts "deleting node = #{node}"
          node.destroy
          puts "deleted node = #{node}"
        rescue => exception
          puts "error deleting node = #{node}"
          puts exception.backtrace
          puts exception
        end
      end
    end

    def startup
      droplet_id = nil

      puts "creating role #{self.type}"
      role = provisioner.create_role

      name = provisioner.node_name
      puts "Provisioning node #{name}"
      droplet = cloud_provider.new_droplet(name, ['transit-tips', self.type])
      droplet_id = droplet.id

      puts "Boostrapping node #{name} with ip #{droplet.public_ip} " \
        "having droplet attributes #{droplet.as_json}"

      result = provisioner.bootstrap(droplet.public_ip)
      raise 'knife bootstrap failed to execute' if result.nil?
      raise 'knife bootstrap returned 1' if result == false
    rescue => exception
      puts 'Error provisioning a new node'
      puts exception.backtrace
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

    private

    attr_writer :type, :recipes, :description, :count

    def provisioner
      @provisioner ||= Chef.new(self.type, self.recipes, self.description)
    end

    def cloud_provider
      DigitalOcean.new
    end
  end
end
