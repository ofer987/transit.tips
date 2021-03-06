require 'google/apis/calendar_v3'

class Ttc::Closure < ActiveRecord::Base
  # line_id, INTEGER, NOT NULL
  # from_station_name, NVARCHAR, NOT NULL
  # to_station_name, NVARCHAR, NOT NULL
  # start_at, DATETIME, NOT NULL
  # end_at, DATETIME, NOT NULL

  has_one :event, foreign_key: 'ttc_closure_id', dependent: :destroy

  validates :line_id, presence: true
  validates :from_station_name, presence: true
  validates :to_station_name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  validates :from_station_name, uniqueness: { scope: [:line_id, :to_station_name, :start_at, :end_at], case_sensitive: false }
  validates :to_station_name, uniqueness: { scope: [:line_id, :from_station_name, :start_at, :end_at], case_sensitive: false }

  def self.current(date)
    where('start_at > ?', date)
  end

  def self.unpublished
    all - joins(:event)
  end

  def published?
    return false if event.nil?

    !event.new_record?
  end

  def match?(other)
    line_id == other.line_id &&
      from_station_name == other.from_station_name &&
      to_station_name == other.to_station_name &&
      start_at.utc.year == other.start_at.utc.year && 
      start_at.utc.month == other.start_at.utc.month && 
      start_at.utc.day == other.start_at.utc.day && 
      end_at.utc.year == other.end_at.utc.year && 
      end_at.utc.month == other.end_at.utc.month && 
      end_at.utc.day == other.end_at.utc.day
  end

  def to_google_event
    ::Google::Apis::CalendarV3::Event.new(
      summary: "No service from #{from_station_name} to #{to_station_name}",
      location: "#{from_station_name} Station",
      description: "No service from #{from_station_name} to #{to_station_name} from #{start_at.to_date} to #{end_at.to_date}",
      start: {
        date_time: start_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
      },
      end: {
        date_time: end_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
      }
    )
  end
end
