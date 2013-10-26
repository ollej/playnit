class GeoLocator
  map: {}
  latlngs: []
  width: 380 
  height: 260
  options:
    zoom: 15
    mapTypeControl: false
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
    mapTypeId: google.maps.MapTypeId.ROADMAP

  constructor: (@sel, @callback, options) ->
    @div = $(sel)
    @callback = callback
    console.log @options
    if options
      @options = _.extend(@options, options)
    # TODO: callback should be event

  gotPosition: (position) =>
    @position = position
    if @div.length > 0
      @addMap position
    if @callback?
      @callback.call this, position

  gotNoPosition: (error) =>
    console.log(error)

  getPosition: ->
    @position

  validPosition: (position) ->
    position && position.coords && position.coords.latitude > 0 && position.coords.longitude > 0

  positionToLatLng: (position) ->
    return unless @validPosition(position)
    new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

  addMap: (positions) ->
    console.log 'addMap', positions
    positions = [positions] unless _.isArray(positions) 
    console.log 'positions', positions
    center = @positionToLatLng(positions[0])
    @addEmptyMap(center)
    @addPositionsAsMarkers(positions)
    this

  addPositionsAsMarkers: (positions) ->
    console.log 'addPositionsAsMarkers', positions
    for position in positions
      if @validPosition(position)
        latlng = @positionToLatLng(position)
        @addMarker(latlng) 
    this

  addEmptyMap: (center) ->
    console.log 'addEmptyMap', center
    $mapDiv = $('<div>', {
      id: 'mapcanvas',
      width: @width,
      height: @height
    })
    console.log(@options)
    options = _.extend({}, @options, { center: center })
    @map = new google.maps.Map($mapDiv[0], options)
    @div.replaceWith($mapDiv)
    this

  addMarker: (latlng) ->
    return unless @map?
    console.log 'addMarker', latlng
    marker = new google.maps.Marker({
      position: latlng,
      map: @map,
      title: "You are here!"
    });
    @latlngs.push(latlng)
    this

  locate: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      console.log('not supported')
    this

(exports ? this).GeoLocator = GeoLocator

