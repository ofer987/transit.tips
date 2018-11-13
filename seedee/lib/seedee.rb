# frozen_string_literal: true

require 'seedee/version'
require 'active_support/all'
require 'chef'
require 'chef/knife/vault_base'
require 'chef-vault'

# Todo replace with configuration file or environment values
Chef::Config.from_file File.join(ENV['HOME'], '.chef', 'config.rb')

# Top-level module
module Seedee
  ROOT = File.expand_path('../..', __FILE__)

  autoload :Farm, 'seedee/farm'
  autoload :DigitalOcean, 'seedee/digital_ocean'
  autoload :Chef, 'seedee/chef'
  autoload :Vaults, 'seedee/vaults'
end
