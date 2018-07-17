# frozen_string_literal: true

require 'seedee/version'
require 'active_support/all'
require 'chef'

# Todo replace with configuration file or environment values
Chef::Config.node_name = 'ofer987'
Chef::Config.client_key = '/Users/ofer987/.chef/rsa_chef'
Chef::Config.chef_server_url = 'https://138.197.155.252/organizations/otium'

# Top-level module
module Seedee
  ROOT = File.expand_path('../..', __FILE__)

  autoload :Farm, 'seedee/farm'
  autoload :DigitalOcean, 'seedee/digital_ocean'
  autoload :Chef, 'seedee/chef'
end
