# frozen_string_literal: true

require_relative '../../spec/spec_helper.rb'
require_relative '../../lib/models/farm.rb'

require 'droplet_kit'

RSpec.describe Farm do
  describe '#build' do
    it { is_expected.to be_a Farm }
  end

  describe '#add_restbus' do
    let(:before_servers) { [] }

    before :each do
      puts "hello"
      puts ENV['DIGITAL_OCEAN_TOKEN']
      before_servers = DropletKit::Client
        .new(access_token: Farm::ACCESS_TOKEN)
        .droplets
        .all
    end

    it 'DigitalOcean has an extra server' do
      after_servers = DropletKit::Client
        .new(access_token: Farm::ACCESS_TOKEN)
        .droplets
        .all

      expect(after_servers.count).to eq(before_servers.count)
    end
  end
end
