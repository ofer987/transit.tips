module Ttc
  module Train
    class Schedule
      class Item
        attr_reader :values

        def initialize(values)
          self.values = values.to_h
        end

        def direction
          Nokogiri::HTML(values['stationDirectionText']).text
        end

        def as_json(_ = nil)
          {
            direction: direction,
            destination: values['trainDestinationStation'],
            at: values['timeString'],
            preciselyAt: values['timeInt'],
            message: values['trainMessage']
          }
        end
        
        private

        attr_writer :values
      end
    end
  end
end
