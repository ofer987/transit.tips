class LinesController < ApplicationController
  def show
    statuses = Line.find_statuses(params[:id], options)

    if statuses.empty?
      render json: {}, status: 404
    else
      render json: {
        statuses: statuses
      }
    end
  end

  private

  def options
    params.permit(:limit, :tweeted_by)
  end
end
