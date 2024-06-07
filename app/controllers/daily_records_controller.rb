class DailyRecordsController < ApplicationController

  def index
    @daily_records = DailyRecord.all
    render json: @daily_records
  end
end
