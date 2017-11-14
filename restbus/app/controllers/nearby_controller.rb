class NearbyController < ApplicationController
  def index
    locations = Endpoints.new(latitude, longitude).nearby_locations

    if locations.present?
      render json: locations
    else
      render status: 500, json: {}
    end
  end

  private

  def longitude
    params[:longitude]
  end

  def latitude
    params[:latitude]
  end
end
