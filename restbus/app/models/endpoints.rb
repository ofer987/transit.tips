class Endpoints
  BASE_URL = 'http://restbus.info/api'.freeze

  def initialize(latitude, longitude)
    self.latitude = latitude.to_f
    self.longitude = longitude.to_f
  end

  def routes
    get_routes
  rescue => exception
    Rails.logger.error exception.full_message

    []
  end

  def address
    Geocoder.address [latitude, longitude]
  rescue => exception
    Rails.logger.error exception.full_message

    nil
  end

  def as_json(_ = nil)
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

  def get_routes
    endpoint = "#{BASE_URL}/locations/#{latitude},#{longitude}/predictions"
    response = RestClient.get(endpoint)

    case response.code
    when 200
      JSON.parse(response.body)
    else
      raise HttpStatusError.new(response.code, "An error has occurred", nil)
    end
  rescue RestClient::NotFound => exception
    raise HttpStatusError.new(404, exception.message, exception.backtrace)
  rescue => exception
    raise HttpStatusError.new(500, exception.message, exception.backtrace)
  end

  attr_accessor :latitude, :longitude
end
