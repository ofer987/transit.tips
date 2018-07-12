# frozen_string_literal: true

require 'seedee/version'
require 'active_support/all'

# Top-level module
module Seedee
  ROOT = File.expand_path('../..', __FILE__)

  autoload :Farm, 'seedee/farm'
  autoload :DigitalOcean, 'seedee/digital_ocean'
  autoload :Chef, 'seedee/chef'
end
