module Ttc
  module Train
    class Schedule
      class Event
        attr_reader :values

        def initialize(values)
          self.values = values.to_h
        end

        def as_json(_ = nil)
          {
            in: values['timeString'],
            preciselyIn: values['timeInt'],
            message: values['trainMessage']
          }
        end
        
        private

        attr_writer :values
      end
    end
  end
end
