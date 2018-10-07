class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:search_param] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def set_place
    @place = BeermappingApi.find(params[:id], session[:search_param])
  end
end