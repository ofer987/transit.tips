module Ttc
  module Train
    class Client
      attr_reader :line_id, :station_id

      def uri
        "http://www.ttc.ca/Subway/loadNtas.action?subwayLine=#{line_id.to_i}&stationId=#{station_id.to_i}"
      end

      def initialize(line_id, station_id)
        self.line_id = line_id.to_i
        self.station_id = station_id.to_i
      end

      def schedule
        response = RestClient.get(uri)

        # Should we bother to check the status code?
        # binding.pry
        JSON
          .parse(response.body)['ntasData']
          .group_by { |item| item['trainDestinationStation'] }
          .map { |(destination_station, events)| Schedule.new(line_id, station_id, destination_station, events) }
      end

      private

      attr_writer :line_id, :station_id
    end
  end
end

