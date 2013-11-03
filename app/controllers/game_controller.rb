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
      games = @bgg.search( {:query => params[:query], :type => 'boardgame'} )
      names = []
      games['item'].each do |game|
        return if game.nil? or !game.has_key? 'name'
        names << game['name'].map { |n| n['value'] }
      end
      names
    end

    def get_api
      @bgg = BggApi.new
    end
end
