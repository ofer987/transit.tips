class NearbyController < ApplicationController
  def index
    render json: Endpoints.new(latitude, longitude).as_json
  rescue HttpStatusError => exception
    render status: exception.code, json: { error: exception.message }
  rescue => exception
    render status: 500, json: { error: exception.message }
  end

  private

  def longitude
    if params[:longitude].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter longitude')
    end

    params[:longitude]
  end

  def latitude
    if params[:latitude].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter latitude')
    end

    params[:latitude]
  end
end
