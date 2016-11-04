class LinesController < ApplicationController
  def index
  end

  def show
    statuses = Line.find_statuses(params[:id])

    if statuses.empty?
      render status: 404
    else
      render json: {
        statuses: statuses
      }
    end
  end
end
