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
        value: id,
        name: name
      }
    end
  end
end
