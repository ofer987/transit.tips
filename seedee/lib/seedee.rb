# frozen_string_literal: true

require 'seedee/version'
require 'active_support/all'

# Top-level module
module Seedee
  autoload :Farm, 'seedee/farm'
  autoload :DigitalOcean, 'seedee/digital_ocean'
  autoload :Chef, 'seedee/chef'
end
