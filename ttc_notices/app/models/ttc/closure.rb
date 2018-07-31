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
end
