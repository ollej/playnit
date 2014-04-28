require 'bgg'

class GameController < ApplicationController
  before_filter :get_api

  def index
    @games = @bgg.get_games(params[:query])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @games.flatten }
    end
  end

  def show
  end

  private
    def get_api
      @bgg = BGG::API.new
    end
end
