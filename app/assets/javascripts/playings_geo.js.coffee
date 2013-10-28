class PlayingsGeo
  initGeo: ->
    if $("#map-edit").length > 0
      @initEdit()
    if $("#map-index").length > 0
      @initIndex()

  initEdit: ->
    geo = new GeoLocator "#map-edit", (position) ->
      $('#playing_longitude').val(position.coords.longitude)
      $('#playing_latitude').val(position.coords.latitude)
    geo.locate();

  initIndex: ->
    geo = new GeoLocator "#map-index"
    geo.addMap(positions)

(exports ? this).PlayingsGeo = PlayingsGeo
