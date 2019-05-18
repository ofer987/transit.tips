require 'geocoder/stores/base'

module Ttc
  module Train
    class Station
      include Geocoder::Store::Base

      def self.geocoder_options
        @geocoder_options ||= {
          units: :km,
          latitude: :latitude,
          longitude: :longitude
        }
      end

      attr_reader :latitude, :longitude

      # reverse_geocoded_by :latitude, :longitude
      #
      def initialize(latitude, longitude)
        self.latitude = latitude.to_f
        self.longitude = longitude.to_f
      end

      def nearest_stations(threshold_kilometres = 2)
        nearest_stations = LINES.values.map do |line|
          stations = line[:stations].values
          nearest_station = shortest_ordered_distance_to(stations)

          [line, nearest_station]
        end.to_h

        nearest_stations
          .reject { |_, station| station.nil? }
      end

      def shortest_ordered_distance_to(stations, threshold_kilometres = 2)
        Array(stations)
          .map { |station| [station, distance_to([station[:latitude], station[:longitude]], :km)] }
          .to_h
          .select { |_, distance| distance <= threshold_kilometres }
          .sort { |(_, a), (_, b)| a <=> b }
          .to_h
          .keys
          .first
      end

      private

      attr_writer :latitude, :longitude
    end
  end
end
