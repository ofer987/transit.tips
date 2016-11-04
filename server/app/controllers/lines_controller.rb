class LinesController < ApplicationController
  def show
    statuses = Line.find_statuses(params[:id])

    if statuses.empty?
      render json: {}, status: 404
    else
      render json: {
        statuses: statuses
      }
    end
  end
end
