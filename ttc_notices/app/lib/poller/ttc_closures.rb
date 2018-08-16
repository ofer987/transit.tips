require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

module Poller
  class TtcClosures
    URI = 'https://www.ttc.ca/Service_Advisories/Subway_closures/index.jsp'

    MONTHS = {
      January: 1,
      February: 2,
      March: 3,
      April: 4,
      May: 5,
      June: 6,
      July: 7,
      August: 8,
      September: 9,
      October: 10,
      November: 11,
      December: 12
    }

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    APPLICATION_NAME = 'Transit.Tips -- TTC Notices'.freeze
    CREDENTIALS_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', 'credentials.json').freeze
    TOKEN_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', 'token.yaml').freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    attr_reader :calendar, :date

    def initialize(calendar, date)
      self.calendar = calendar
      self.date = date
    end

    def sync_future_closures
      delete_cancelled_closures(save_current)
    end

    def save_current
      count = 0
      get_current.each do |closure|
        begin
          # Fail if this closure already exists
          closure.save!
          count += 1
        rescue => exception
          Rails.logger.error("Failed to save the Ttc::Closure (#{closure.inspect})")
          Rails.logger.error(exception.message)
          Rails.logger.error(exception.backtrace.join("\n"))
        end
      end

      count
    end

    def get_current
      body = RestClient.get(URI).body
      document = Nokogiri::HTML(body)

      document
        .css('.main-content h4')
        .map(&:content)
        .map { |content| parse(content) }
        .reject(&:nil?)
    end

    def publish(closure)
      google_event = closure.to_google_event
      result = service.insert_event(calendar.google_calendar_id, google_event)

      ::Event.create!(
        calendar: calendar,
        ttc_closure_id: closure.id,
        google_event_id: result.id,
        name: google_event.summary,
        description: google_event.description
      )
    rescue => exception
      Rails.logger.error("Error publishing ttc closure (#{closure.inspect}) to calendar (#{calendar.id})")
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))

      raise exception
    end

    def delete_cancelled_closures(actual_closures)
      Ttc::Closure.current(date).each do |item|
        begin
          if !actual_closures.any? { |actual| actual.match?(item) }
            item.destroy!
            remove_from_calendar!(item.event.google_event_id)
          end
        rescue => exception
          raise
          Rails.logger.error("Error deleting ttc_closure (#{item.inspect}) to calendar (#{calendar.id})")
          Rails.logger.error(exception.message)
          Rails.logger.error(exception.backtrace.join("\n"))
          Rails.logger.error("Trying to publish next event")
        end
      end
    end
    
    private

    attr_writer :calendar, :date

    def remove_from_calendar!(google_event_id)
      service.delete_event(calendar.google_calendar_id, google_event_id_id)
    end

    def service
      return @service if !@service.nil?

      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = credentials

      @service
    end

    def credentials
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      authorizer.get_credentials(user_id)
    end

    def parse(content)
      puts content
      matches = /Line\s*(.+)\s*:\s*(.+)\s*to\s*(.+)\s*closure\s*on\s*(\w+)\s*(\w+)\s*and\s*(\w+)/.match(content.to_s)

      if matches.nil?
        puts "no matches???"
      end

      return nil if matches.nil?

      Ttc::Closure.new(
        line_id: matches[1].to_i,
        from_station_name: matches[2].to_s.strip,
        to_station_name: matches[3].to_s.strip,
        start_at: Time.zone.local(DateTime.now.year, MONTHS[matches[4].to_s.strip.to_sym], matches[5].to_i).beginning_of_day,
        end_at: Time.zone.local(DateTime.now.year, MONTHS[matches[4].to_s.strip.to_sym], matches[6].to_i).end_of_day
      )
    end
  end
end
