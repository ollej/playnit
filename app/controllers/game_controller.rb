require 'bgg'

class GameController < ApplicationController
  before_filter :get_api

  def index
    @games = get_names

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @games.flatten }
    end
  end

  def show
  end

  private
    #def game_params
    #  params.permit(:query)
    #end
    def get_names
      @bgg.get_names(params[:query])
    end

    def get_api
      @bgg = BGG::API.new
    end
end
