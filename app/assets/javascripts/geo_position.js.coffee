class GeoPosition
  position: {}

  constructor: (@position) ->
    logger.debug "GeoPosition.constructor", @position

  long: =>
    @position.coords.longitude

  lat: =>
    @position.coords.latitude

  @fromGeoPos: (lat, lng) ->
    new GeoPosition
      coords:
        latitude: lat,
        longitude: lng

  @fromGeoLocations: (positions) ->
    logger.debug 'GeoPosition.fromGeoLocations', positions
    positions = [positions] unless _.isArray(positions)
    for position in positions
      position = new GeoPosition(position)

  @fromGPS: (gps) ->
    logger.debug 'GeoPosition.fromGPS', gps
    lat = GeoPosition.convertDMS(gps.GPSLatitude, gps.GPSLatitudeRef)
    long = GeoPosition.convertDMS(gps.GPSLongitude, gps.GPSLongitudeRef)
    position = {
      coords: {
        latitude: lat,
        longitude: long
      }
    }
    return new GeoPosition(position)

  @convertDMS: (dms, ref) ->
    logger.debug 'GeoPosition.convertDMS', dms, ref
    degrees = dms[0]
    minutes = dms[1]
    seconds = dms[2]

    dd = degrees + (minutes / 60.0) + (seconds / (60.0 * 60.0))
    dd = parseFloat(dd)

    if (ref == "S" || ref == "W")
      dd = dd * -1.0

    logger.debug 'GeoPosition.convertDMS result:', dd
    return dd

  valid: =>
    @position && @position.coords && @position.coords.latitude? && @position.coords.longitude?

  toLatLng: =>
    new google.maps.LatLng(@lat(), @long())

(exports ? this).GeoPosition = GeoPosition

