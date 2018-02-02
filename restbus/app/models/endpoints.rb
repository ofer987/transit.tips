class Endpoints
  BASE_URL = 'http://restbus.info/api'.freeze

  def initialize(latitude, longitude)
    self.latitude = latitude.to_f
    self.longitude = longitude.to_f
  end

  def routes
    endpoint = "#{BASE_URL}/locations/#{latitude},#{longitude}/predictions"
    response = RestClient.get(endpoint)

    case response.code
    when 200
      JSON.parse(response.body)
    else
      raise HttpStatusError.new(response.code, 'an error has occurred')
    end
  end

  def address
    Geocoder.address [latitude, longitude]
  end

  def as_json
    {
      latitude: latitude,
      longitude: longitude,
      routes: routes,
      address: address
    }
  end

  def to_json
    as_json.to_s
  end

  private

  attr_accessor :latitude, :longitude
end
