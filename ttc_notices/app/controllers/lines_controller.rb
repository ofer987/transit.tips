class LinesController < ApplicationController
  def show
    line = Line.find(params[:id], options)

    if line.nil?
      render json: {}, status: 404
    else
      render json: line
    end
  end

  private

  def options
    params.permit(:limit, :tweeted_by)
  end
end
