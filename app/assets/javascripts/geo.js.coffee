class Geo
  constructor: (callback) ->
    @callback = callback

  gotPosition: (position) =>
    @position = position
    if @callback?
      @callback.call this, position

  gotNoPosition: (error) =>
    console.log(error)

  getPosition: ->
    @position

  locate: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      console.log('not supported')

(exports ? this).Geo = Geo

