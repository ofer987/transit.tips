module Ttc
  module Train
    class Client
      attr_reader :line_id, :station_id

      def uri
        "http://www.ttc.ca/Subway/loadNtas.action?subwayLine=#{line_id}&stationId=#{station_id}"
      end

      def initialize(line_id, station_id)
        self.line_id = line_id.to_i
        self.station_id = station_id.to_i
      end

      def line
        LINES.values
          .select { |line| line[:id] == line_id }
          .first
      end

      def events
        response = RestClient.get(uri)

        # Should we bother to check the status code?
        JSON
          .parse(response.body)['ntasData']
          .select { |item| item['subwayLine'] == line[:internal_name] }
          .group_by { |item| item['trainDestinationStation'] }
          .map { |(destination_station, events)| Direction.new(destination_station, events) }
      end

      private

      attr_writer :line_id, :station_id
    end
  end
end

