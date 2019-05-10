module Ttc
  module Train
    class Direction
      class Event
        attr_reader :values

        def initialize(values)
          self.values = values.to_h
        end

        def as_json(_ = nil)
          {
            approximately_in: values['timeString'],
            precisely_in: values['timeInt'],
            message: values['trainMessage']
          }
        end
        
        private

        attr_writer :values
      end
    end
  end
end
