class Endpoints
  BASE_URL = 'http://restbus.info/api'.freeze

  def initialize(latitude, longitude)
    self.latitude = latitude.to_f
    self.longitude = longitude.to_f
  end

  def nearby_locations
    endpoint = "#{BASE_URL}/locations/#{latitude},#{longitude}/predictions"

    response = RestClient.get(endpoint)

    case response.code
    when 200
      return JSON.parse(response.body)
    end
  end

  private

  attr_accessor :latitude, :longitude
end
