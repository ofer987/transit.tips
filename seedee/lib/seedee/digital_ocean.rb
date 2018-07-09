# frozen_string_literal: true

require 'seedee/version'
require 'droplet_kit'

module Seedee
  # Talk to Digital Ocean
  class DigitalOcean
    ACCESS_TOKEN = ENV['DIGITAL_OCEAN_TOKEN']
    TRAVIS_BUILD_DIR = ENV['TRAVIS_BUILD_DIR']

    def new_droplet(name)
      user_data = File.read(File.join(Seedee::ROOT, 'modify-hosts'))
      droplet = DropletKit::Droplet.new(
        name: name.to_s.strip,
        region: 'tor1',
        image: 'ubuntu-16-04-x64',
        size: 's-1vcpu-1gb',
        user_data: user_data,
        monitoring: true,
        ssh_keys: Array(ssh_keys)
      )

      await_active_droplet client.droplets.create(droplet)
    end

    def destroy_droplet(id)
      client.droplets.delete(id: id.to_s)
    rescue StandardError
      puts "error deleting droplet with id = '#{id}'"
    end

    def await_active_droplet(droplet)
      client.droplets.find(id: droplet.id).tap do |result|
        if result.status != 'active'
          sleep(1)
          return await_active_droplet(droplet)
        end
      end
    end

    private

    def client
      @client ||= DropletKit::Client.new(access_token: ACCESS_TOKEN)
    end

    def ssh_keys
      [15_237_447, 21_963_843]
    end
  end
end
