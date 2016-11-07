class Endpoints
  BASE_URL = 'http://restbus.info/api'.freeze

  def initialize(longitude, latitude)
    @longitude = longitude.to_f
    @latitude = latitude.to_f
  end

  def nearby_locations
    endpoint = "#{BASE_URL}/locations/#{@longitude},#{@latitude}/predictions"

    response = RestClient.get(endpoint)

    case response.code
    when 200
      return JSON.parse(response.body)
    end
  end
end
