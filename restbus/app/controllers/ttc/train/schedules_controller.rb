class Ttc::Train::SchedulesController < ApplicationController
  def show
    render json: Ttc::Train::Client
      .new(line, station)
      .arrivals
  rescue HttpStatusError => exception
    render status: exception.code, json: { error: exception.message, backtrace: exception.backtrace }
  rescue => exception
    render status: 500, json: { error: exception.message, backtrace: exception.backtrace }
  end

  private

  def line
    if params[:line].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter (line)')
    end

    params[:line]
  end

  def station
    if params[:station].nil?
      raise HttpStatusError.new(:bad_request, 'missing query parameter (station)')
    end

    params[:station]
  end
end
