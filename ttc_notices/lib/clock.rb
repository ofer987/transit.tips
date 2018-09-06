require 'rubygems'
require 'clockwork'

module Clockwork
  here_path = File.dirname(__FILE__)
  environment = ENV['RAILS_ENV'] || 'development'
  environment_filename = "#{environment}.log"

  log_path = "#{File.join(here_path, '..', 'log', environment_filename)}"
  logger = ::Logger.new(log_path)

  twitter_job = 'twitter:poll'
  ttc_closures_job = 'ttc_closures:poll'

  handler do |job|
    logger.info "[#{DateTime.now}]: Running #{job}"
  end

  begin
    every(1.minute, twitter_job) do
      `cd #{File.join(here_path, '..')} && rake #{twitter_job}`
    end

    every(1.day, ttc_closures_job) do
      `cd #{File.join(here_path, '..')} && rake #{ttc_closures_job}`
    end
  rescue => e
    message =
      "[#{DateTime.now}]: Error running #{twitter_job}\n" <<
      "type: #{e.class}\n" <<
      "error: #{e.message}\n" <<
      "backtrace: #{e.backtrace}"

    logger.error(message)
  end
end
