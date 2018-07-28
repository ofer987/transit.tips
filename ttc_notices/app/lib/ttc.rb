class TTC
  CLOSURES_URI = 'https://www.ttc.ca/Service_Advisories/Subway_closures/index.jsp'

  def initialize
  end

  def get_closures
    body = RestClient.get(CLOSURES_URI).body
    document = Nokogiri::HTML(body)

    document.css('.main-content h4').map(&:content)
  end
end
