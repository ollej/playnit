# http://www.boardgamegeek.com/xmlapi2/search?type=boardgame&query=

module BGG
  class Game
    def initialize(data = {})
      @data = data
    end

    def id
      @data['id']
    end

    def name
      @name ||= get_value('name')
    end

    def yearpublished
      @yearpublished ||= get_value('yearpublished')
    end

    def get_value(key, default_value=nil)
      if @data.has_key? key
        @data[key].first.fetch('value', default_value)
      else
        default_value
      end
    end

    def label
      if yearpublished
        "#{name} (#{yearpublished})"
      else
        name
      end
    end

    def as_game_selector_data
      {
        label: label,
        value: id
      }
    end
  end

  class API
    def initialize
      @bgg = BggApi.new

      def get_games(query)
        games = @bgg.search( {:query => query, :type => 'boardgame'} )
        names = []
        return names if games['item'].nil?
        games['item'].each do |game|
          return if game.nil? or !game.has_key? 'name'
          game = BGG::Game.new(game)
          names << game.as_game_selector_data
        end
        names
      end
    end
  end
end
