class RoutesController < ApplicationController
  def index
    render MoreEndpoints.new.routes(agency_id)
  end

  def show
    render MoreEndpoints.new.route(agency_id, id)
  end

  private

  def agency_id
    params[:agency_id]
  end

  def id
    params[:id]
  end
end
