module Poller
  class TtcClosures
    URI = 'https://www.ttc.ca/Service_Advisories/Subway_closures/index.jsp'

    MONTHS = {
      January: 1,
      February: 2,
      March: 3,
      April: 4,
      May: 5,
      June: 6,
      July: 7,
      August: 8,
      September: 9,
      October: 10,
      November: 11,
      December: 12
    }

    def initialize
    end

    def get_current
      body = RestClient.get(URI).body
      document = Nokogiri::HTML(body)

      document
        .css('.main-content h4')
        .map(&:content)
        .map { |content| parse(content) }
        .reject(&:nil?)
    end
    
    private

    def parse(content)
      matches = /Line (.+): (.+) to (.+) closure on (\w+) (\w+) and (\w+)/.match(content.to_s)

      return nil if matches.nil?

      ::Ttc::Closure.create(
        line_id: matches[1].to_i,
        from_station_name: matches[2].to_s.strip,
        to_station_name: matches[3].to_s.strip,
        start_at: DateTime.new(DateTime.now.year, MONTHS[matches[4].to_sym], matches[5].to_i).beginning_of_day,
        end_at: DateTime.new(DateTime.now.year, MONTHS[matches[4].to_sym], matches[6].to_i).end_of_day
      )
    end
  end
end
