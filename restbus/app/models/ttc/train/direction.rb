module Ttc
  module Train
    class Direction
      attr_reader :destination_station, :events

      def initialize(destination_station, events)
        self.destination_station = destination_station.to_s.strip
        self.events = Array(events).map { |time| Event.new(time) }
      end

      def as_json(_ = nil)
        {
          destination_station: destination_station,
          events: events.as_json
        }
      end

      private

      attr_writer :destination_station, :events
    end
  end
end
