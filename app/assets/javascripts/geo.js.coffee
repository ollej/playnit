class GeoLocator
  constructor: (@sel, @callback) ->
    @div = $(sel)
    @callback = callback
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

  addMap: (position) ->
    return unless @validPosition(position)
    $mapDiv = $('<div>', {
      id: 'mapcanvas',
      width: 640,
      height: 480
    })
    latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    options = {
      zoom: 15,
      center: latlng,
      mapTypeControl: false,
      navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map($mapDiv[0], options);
    marker = new google.maps.Marker({
      position: latlng,
      map: map,
      title: "You are here! (at least within a #{position.coords.accuracy} meter radius)"
    });
    @div.replaceWith($mapDiv)

  locate: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotPosition, @gotNoPosition)
    else
      console.log('not supported')
    this

(exports ? this).GeoLocator = GeoLocator

