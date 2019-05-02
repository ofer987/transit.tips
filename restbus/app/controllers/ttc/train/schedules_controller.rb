class Ttc::Train::SchedulesController < ApplicationController
  def show
    
    render json: schedules(closest_stations)
  rescue HttpStatusError => exception
    render status: exception.code, json: { error: exception.message, backtrace: exception.backtrace }
  rescue => exception
    render status: 500, json: { error: exception.message, backtrace: exception.backtrace }
  end

  private

  def closest_stations
    Ttc::Train::Station.closest_stations(latitude, longitude)
  end

  def schedules(lines)
    lines.map do |(line_id, station)|
      {
        line_id: line_id,
        station_id: station[:id],
        schedule: arrivals(line, station)
      }
    end
  end

  def schedule(line_name, station_name)
    Client.new(line_name, station_name).schedule
  end

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
