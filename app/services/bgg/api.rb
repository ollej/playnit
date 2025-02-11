# http://www.boardgamegeek.com/xmlapi2/search?type=boardgame&query=

module BGG
  class API
    CACHE_EXPIRE = 60 * 60 * 24 * 8

    def initialize
      @bgg = BggApi.new
      @redis = Redis.new
    end

    def redis_key(key)
      "bggsearch:#{key}"
    end

    def search(query_hash)
      key = redis_key(query_hash[:query])
      result = @redis.get(key)
      if result.nil?
        #puts "cache miss: #{key}"
        result = @bgg.search( query_hash )
        @redis.set(key, JSON.dump(result))
        @redis.expire key, CACHE_EXPIRE
      else
        #puts "cache hit: #{key}"
        result = JSON.load(result)
        #puts "result: #{result.inspect}"
      end
      result
    end

    def get_games(query)
      games = search( {:query => query, :type => 'boardgame'} )
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
