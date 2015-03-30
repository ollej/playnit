class GeoLocator
  map: {}
  latlngs: []
  width: 640
  height: 480
  options:
    mapTypeControl: false
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
    mapTypeId: google.maps.MapTypeId.ROADMAP

  constructor: (@sel, @callback, options) ->
    @div = $(@sel)
    console.log @options
    if options
      @options = _.extend(@options, options)
    # TODO: callback should be event

  gotPosition: (position) =>
    positions = GeoPosition.fromGeoLocations(position)

    if @div.length > 0
      @addMap positions
    if @callback?
      @callback.call this, positions

  gotNoPosition: (error) =>
    Flasher.warning("Failed to get position.")
    @addMapUnavailable()

  getPosition: =>
    @position

  addMapUnavailable: ->
    $(".map-container").replaceWith("<div class='map-unavailable'></div>")

  addMap: (positions) =>
    console.log 'addMap positions', positions
    positions = [positions] unless _.isArray(positions)
    console.log 'positions', positions
    if (positions.length == 1 && !positions[0].valid())
      @addMapUnavailable()
      return this
    @addEmptyMap()
    console.log('addMap @map', @map)
    if positions.length == 1
      @map.setCenter(positions[0].toLatLng())
      @map.setZoom(15)
    else
      @setBounds(positions)
    @addPositionsAsMarkers(positions)
    this

  setBounds: (positions) =>
    latlngbounds = new google.maps.LatLngBounds()
    for position in positions
      latlng = position.toLatLng()
      console.log 'setBounds', position, latlng
      latlngbounds.extend(latlng)
    @map.setCenter latlngbounds.getCenter()
    @map.fitBounds latlngbounds

  addPositionsAsMarkers: (positions) =>
    console.log 'addPositionsAsMarkers', positions
    for position in positions
      if position.valid()
        latlng = position.toLatLng()
        @addMarker(latlng)
    this

  addEmptyMap: =>
    console.log 'addEmptyMap'
    $mapDiv = $('<div>', {
      id: 'mapcanvas',
      width: @width,
      height: @height
    })
    console.log(@options)
    options = _.extend({}, @options)
    @map = new google.maps.Map($mapDiv[0], options)
    @div.replaceWith($mapDiv)
    this

  addMarker: (latlng) =>
    return unless @map?
    console.log 'addMarker', latlng
    marker = new google.maps.Marker({
      position: latlng,
      map: @map,
      title: "You are here!"
    })
    @latlngs.push(latlng)
    this

  locate: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      Flasher.warning('No geolocation available.')
    this

(exports ? this).GeoLocator = GeoLocator

