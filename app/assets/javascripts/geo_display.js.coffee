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
    if options
      @options = _.extend(@options, options)

  addMapUnavailable: ->
    @div.html("<div class='map-unavailable'></div>")

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

(exports ? this).GeoDisplay = GeoDisplay

