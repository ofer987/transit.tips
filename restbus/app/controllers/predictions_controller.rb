class PredictionsController < ApplicationController
  def index
    render MoreEndpoints.new.predictions(agency_id, route_id, stop_id)
  end

  private

  def agency_id
    params[:agency_id]
  end

  def route_id
    params[:route_id]
  end

  def stop_id
    params[:stop_id]
  end
end
