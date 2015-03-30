class GeoPosition
  position: {}

  constructor: (@position) ->
    console.log("Creating GeoPosition", @position)

  long: =>
    @position.coords.longitude

  lat: =>
    @position.coords.latitude

  getPosition: =>
    @position

  @fromGeoLocations: (positions) ->
    positions = [positions] unless _.isArray(positions)
    for position in positions
      position = new GeoPosition(position)

  valid: =>
    @position && @position.coords && @position.coords.latitude? && @position.coords.longitude?

  toLatLng: =>
    console.log('asdfasf', @lat(), @long())
    new google.maps.LatLng(@lat(), @long())

(exports ? this).GeoPosition = GeoPosition

