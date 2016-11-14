class ReportController < ApplicationController
  before_action :set_line, only: [:index]

  def index
    report = Report.new({ statuses: @line.statuses })

    render json: report
  end

  private

  def set_line
    @line = Line.find(params[:line_id], {
      tweeted_by: twenty_minutes_ago,
      limit: 20
    })
  end

  def twenty_minutes_ago
    DateTime.now.utc - 20.minutes
  end
end
