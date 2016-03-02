class StatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.json
  def index
    statuses = Status
      .where('? IS NULL OR line_id = ?', line_id, line_id)
      .where('? IS NULL OR tweeted_at >= ?', from_datetime, from_datetime)
      .order(tweeted_at: :desc)
      .limit(100)

    render json: statuses
  end

  private

  def line_id
    params[:line_id]
  end

  def from_datetime
    params[:from_datetime]
  end
end
