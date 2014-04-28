# http://www.boardgamegeek.com/xmlapi2/search?type=boardgame&query=

module BGG
  class API
    def initialize
      @bgg = BggApi.new

      def get_games(query)
        games = @bgg.search( {:query => query, :type => 'boardgame'} )
        names = []
        return names if games['item'].nil?
        games['item'].each do |game|
          return if game.nil? or !game.has_key? 'name'
          names << game['name'].map do |name|
            {
              label: name['value'],
              value: game['id']
            }
          end
        end
        names
      end

      def get_names(query)
        games = @bgg.search( {:query => query, :type => 'boardgame'} )
        names = []
        return names if games['item'].nil?
        games['item'].each do |game|
          return if game.nil? or !game.has_key? 'name'
          names << game['name'].map { |n| n['value'] }
        end
        names
      end
    end
  end
end
