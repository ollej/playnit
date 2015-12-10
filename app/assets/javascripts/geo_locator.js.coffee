class GeoLocator
  options: {}

  constructor: (@success, @fail, options) ->
    logger.debug 'GeoLocator.constructor', options
    if options
      @options = _.extend(@options, options)
    # TODO: callback should be event

  gotPosition: (position) =>
    logger.debug 'GeoLocator.gotPosition', position
    positions = GeoPosition.fromGeoLocations(position)

    if @success?
      @success.call this, positions

  gotNoPosition: (error) =>
    Flasher.warning("Failed to get position.")
    if @fail?
      @fail.call this

  locate: =>
    if navigator.geolocation
      logger.debug 'GeoLocator.locate navigator.geolocation available'
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      Flasher.warning('No geolocation available.')
    this

(exports ? this).GeoLocator = GeoLocator

