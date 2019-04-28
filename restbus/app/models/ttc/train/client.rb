module Ttc
  module Train
    class Client
      attr_reader :line, :station

      def uri
        "http://www.ttc.ca/Subway/loadNtas.action?subwayLine=#{line_id.to_i}&stationId=#{station_id.to_i}"
      end

      def initialize(line, station)
        self.line = line.to_s.strip
        self.station = station.to_s.strip
      end

      def line_id
        Ttc::Train::LINES[line]
      end

      def station_id
        Ttc::Train::STATIONS[station]
      end

      def arrivals
        response = RestClient.get(uri)

        # Should we bother to check the status code?
        data = JSON
          .parse(response.body)['ntasData']
          .group_by { |item| item['trainDirection'] }
          .map { |(direction, items)| Schedule.new(line, station, direction, items) }
      end

      private

      attr_writer :line, :station
    end
  end
end

