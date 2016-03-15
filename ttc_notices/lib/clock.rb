require 'rubygems'
require 'clockwork'

module Clockwork
  environment = ENV['RAILS_ENV'] || 'development'
  logger = ::Logger.new("log/#{environment}.log")
  twitter_job = 'twitter:poll'

  handler do |job|
    logger.info "[#{DateTime.now}]: Running #{job}"
  end

  begin
    every(1.minute, twitter_job, at: '**:**') do
      `rake #{twitter_job}`
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
