require 'google/apis/calendar_v3'

class Ttc::Closure < ActiveRecord::Base
  # line_id, INTEGER, NOT NULL
  # from_station_name, NVARCHAR, NOT NULL
  # to_station_name, NVARCHAR, NOT NULL
  # start_at, DATETIME, NOT NULL
  # end_at, DATETIME, NOT NULL

  validates :line_id, presence: true
  validates :from_station_name, presence: true
  validates :to_station_name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  validates :from_station_name, uniqueness: { scope: [:line_id, :to_station_name, :start_at, :end_at], case_sensitive: false }
  validates :to_station_name, uniqueness: { scope: [:line_id, :from_station_name, :start_at, :end_at], case_sensitive: false }

  def self.current
    all
  end

  def to_event
    ::Google::Apis::CalendarV3::Event.new(
      summary: "No service from #{from_station_name} to #{to_station_name}",
      location: "#{from_station_name} Station",
      description: "No service from #{from_station_name} to #{to_station_name} from #{start_at.to_date} to #{end_at}.to_date",
      start: {
        date_time: start_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
      },
      end: {
        date_time: end_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
      }
    )
  end
end