# frozen_string_literal: true

require 'seedee/version'
require 'droplet_kit'

# Talk to Digital Ocean
class Seedee
  ACCESS_TOKEN = ENV['DIGITAL_OCEAN_TOKEN']

  def new_droplet(name)
    droplet = DropletKit::Droplet.new(
      name: name.to_s.strip,
      region: 'tor1',
      image: 'ubuntu-16-04-x64',
      size: 's-1vcpu-1gb',
      ssh_keys: Array(ssh_keys)
    )

    await_active_droplet! client.droplets.create(droplet)
  end

  def await_active_droplet!(droplet)
    client.droplets.find(id: droplet.id).tap do |result|
      if result.status != 'active'
        sleep(1)
        return await_active_droplet!(droplet)
      end
    end
  end

  private

  def client
    @client ||= DropletKit::Client.new(access_token: ACCESS_TOKEN)
  end

  def ssh_keys
    [15_237_447]
  end
end
