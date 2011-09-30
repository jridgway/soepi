class ChartsController < ApplicationController
  def index 
    @charts = Chart.page(params[:page]).per(10)
  end
end
