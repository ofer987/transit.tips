class MoreEndpoints
  BASE_URL = 'http://restbus.info/api'.freeze

  def routes(agency_id)
    get "#{BASE_URL}/agencies/#{agency_id}/routes"
  end

  def route(agency_id, route_id)
    get "#{BASE_URL}/agencies/#{agency_id}/routes/#{route_id}"
  end

  def predictions(agency_id, route_id, stop_id)
    get "#{BASE_URL}/agencies/#{agency_id}/routes/#{route_id}/stops/#{stop_id}/predictions"
  end

  private

  def get(endpoint)
    response = RestClient.get(endpoint)

    case response.code
    when 200
      { status: 200, json: response.body }
    else
      { status: 500, json: {} }
    end
  rescue RestClient::NotFound => exception
    { status: 404, json: {} }
  end
end
