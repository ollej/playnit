class GeoLocator
  options: {}

  constructor: (@success, @fail, options) ->
    console.log @options
    if options
      @options = _.extend(@options, options)
    # TODO: callback should be event

  gotPosition: (position) =>
    positions = GeoPosition.fromGeoLocations(position)

    if @success?
      @success.call this, positions

  gotNoPosition: (error) =>
    Flasher.warning("Failed to get position.")
    if @fail?
      @fail.call this

  locate: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      Flasher.warning('No geolocation available.')
    this

(exports ? this).GeoLocator = GeoLocator

