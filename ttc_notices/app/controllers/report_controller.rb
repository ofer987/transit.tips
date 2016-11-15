class ReportController < ApplicationController
  before_action :set_line, only: [:index]

  def index
    report = @line.report

    if report.nil?
      render json: {}, status: :not_found
    else
      render json: report
    end
  end

  private

  def set_line
    @line = Line.find(params[:line_id].to_i, {
      tweeted_by: twenty_minutes_ago,
      limit: 20
    })
  end

  def twenty_minutes_ago
    20.minutes.ago
  end
end
