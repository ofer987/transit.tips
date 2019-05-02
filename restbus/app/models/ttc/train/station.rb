module Ttc
  module Train
    class Station
      def self.closest_stations(reference_latitude, reference_longitude, threshold_kilometres = 2)
        closest_stations = LINES.values.map do |line|
          stations = line[:stations].values
          closest_station = shortest_ordered_distance_to(reference_latitude, reference_longitude, stations)

          [line[:id], closest_station]
        end.to_h

        closest_stations
          .reject { |(_, station)| station.nil? }
      end

      def self.shortest_ordered_distance_to(reference_latitude, reference_longitude, stations, threshold_kilometres = 2)
        datum = Geocoder.new(reference_latitude.to_f, reference_longitude.to_f)

        Array(stations)
          .map { [station, datum.distance_to([station[:latitude], station[:longitude]], :km)] }
          .to_h
          .filter { |(_, distance)| distance <= threshold_kilometres }
          .sort { |(_, a), (_, b)| b <=> a }
          .to_h
          .values
          .first
      end
    end
  end
end
