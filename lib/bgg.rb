# http://www.boardgamegeek.com/xmlapi2/search?type=boardgame&query=

module BGG
  class API
    attr_accessor :base_url, :type
    @base_url = 'http://www.boardgamegeek.com/xmlapi2'
    @type = 'boardgame'

    def search(query)
      url = "#{@base_url}/search?type=#{type}&query=#{query}"
      url
    end

  end
end
