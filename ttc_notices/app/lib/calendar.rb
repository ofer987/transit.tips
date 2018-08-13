#!/usr/bin/env ruby
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

require 'pry-byebug'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Transit.Tips -- TTC Notices'.freeze
CREDENTIALS_PATH = File.join(File.dirname(__FILE__), '..', '..', 'credentials.json').freeze
TOKEN_PATH = File.join(File.dirname(__FILE__), '..', '..', 'token.yaml').freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# binding.pry

# Fetch the next 10 events for the user
# TTCC calendar
calendar_id = 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com'
response = service.list_events(calendar_id,
                               max_results: 100,
                               single_events: true,
                               order_by: 'startTime',
                               time_min: Time.now.iso8601)
puts 'Upcoming events:'
puts 'No upcoming events found' if response.items.empty?
response.items.each do |event|
  start = event.start.date || event.start.date_time
  puts "- #{event.summary} (#{start})"
end

# return

puts 'insert event'
event = Google::Apis::CalendarV3::Event.new(
  summary: 'Lawrence West is spelled correctly',
  location: 'Lawrence West Station',
  description: 'No service between Lawrence West to Finch West stations',
  start: {
    date_time: '2018-08-18T00:00:00-04:00',
    time_zone: 'America/Toronto',
  },
  end: {
    date_time: '2018-08-18T17:00:00-04:00',
    time_zone: 'America/Toronto',
  }
)

result = service.insert_event(calendar_id, event)
puts "Event created: #{result.html_link}"

response = service.list_events(calendar_id, max_results: 1000)
response.items.each do |event|
  service.delete_event(calendar_id, event.id)
end
