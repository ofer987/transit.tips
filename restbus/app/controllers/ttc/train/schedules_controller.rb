class Ttc::Train::SchedulesController < ApplicationController
  def show
    render json: as_json
  rescue HttpStatusError => exception
    render status: exception.code, json: { error: exception.message, backtrace: exception.backtrace }
  rescue => exception
    render status: 500, json: { error: exception.message, backtrace: exception.backtrace }
  end

  private

  def nearest_stations
    Ttc::Train::Station.new(latitude, longitude).nearest_stations
  end

  def as_json(_ = nil)
    {
      longitude: longitude,
      latitude: latitude,
      lines: lines
    }
  end

  def lines
    nearest_stations.map do |(line, station)|
      {
        id: line[:id],
        name: line[:name],
        stations: [{
          id: station[:id],
          name: station[:name],
          longitude: station[:longitude],
          latitude: station[:latitude],
          directions: Array(events(line[:id], station[:id]))
        }],
      }
    end
  end

  def events(line_id, station_id)
    Ttc::Train::Client.new(line_id, station_id).events
  end

  def longitude
    if params[:longitude].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter longitude')
    end

    params[:longitude].to_f
  end

  def latitude
    if params[:latitude].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter latitude')
    end

    params[:latitude].to_f
  end
end