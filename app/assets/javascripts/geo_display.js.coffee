class GeoDisplay
  width: 640
  height: 480
  latlngs: []
  map: {}
  options:
    mapTypeControl: false
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
    mapTypeId: google.maps.MapTypeId.ROADMAP

  constructor: (@sel, options) ->
    @div = $(@sel)
    logger.debug 'GeoDisplay.constructor', @sel, options, @div
    if options
      @options = _.extend(@options, options)

  addMapUnavailable: ->
    logger.debug 'GeoDisplay.addMapUnavailable'
    @div.html("<div class='map-unavailable'></div>")

  addMap: (positions) =>
    logger.debug 'GeoDisplay.addMap positions:', positions
    positions = [positions] unless _.isArray(positions)
    logger.debug 'GeoDisplay.addMap positions wrapped:', positions
    if (positions.length == 1 && !positions[0].valid())
      logger.warn 'GeoDisplay.addMap - Position is invalid'
      @addMapUnavailable()
      return this
    @addEmptyMap()
    logger.debug 'GeoDisplay.addMap @map', @map
    if positions.length == 1
      @map.setCenter(positions[0].toLatLng())
      @map.setZoom(15)
    else
      @setBounds(positions)
    @addPositionsAsMarkers(positions)
    this

  setBounds: (positions) =>
    logger.debug 'GeoDisplay.setBounds', positions
    latlngbounds = new google.maps.LatLngBounds()
    for position in positions
      latlng = position.toLatLng()
      logger.debug 'GeoDisplay.setBounds position', position, latlng
      latlngbounds.extend(latlng)
    @map.setCenter latlngbounds.getCenter()
    @map.fitBounds latlngbounds

  addPositionsAsMarkers: (positions) =>
    logger.debug 'GeoDisplay.addPositionsAsMarkers', positions
    for position in positions
      if position.valid()
        latlng = position.toLatLng()
        @addMarker(latlng)
    this

  addEmptyMap: =>
    logger.debug 'GeoDisplay.addEmptyMap'
    $mapDiv = $('<div>', {
      id: 'mapcanvas',
      width: @width,
      height: @height
    })
    logger.debug 'GeoDisplay.addEmptyMap @options', @options
    options = _.extend({}, @options)
    @map = new google.maps.Map($mapDiv[0], options)
    @div.replaceWith($mapDiv)
    this

  addMarker: (latlng) =>
    return unless @map?
    logger.debug 'GeoDisplay.addMarker', latlng
    marker = new google.maps.Marker({
      position: latlng,
      map: @map,
      title: "You are here!"
    })
    @latlngs.push(latlng)
    this

(exports ? this).GeoDisplay = GeoDisplay

