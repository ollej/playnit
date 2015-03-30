class PlayingsGeo
  initGeo: ->
    if $("#map-edit").length > 0
      @initEdit()
    if $("#map-index").length > 0
      @initIndex()
    if $("#map-show").length > 0
      @initShow()

  initEdit: ->
    geo = new GeoLocator "#map-edit", (positions) ->
      position = positions[0]
      $('#playing_longitude').val(position.long)
      $('#playing_latitude').val(position.lat)
    geo.locate()

  initIndex: ->
    geo = new GeoLocator "#map-index"
    if positions?
      geo.addMap(GeoPosition.fromGeoLocations(positions))

  initShow: ->
    geo = new GeoLocator "#map-show"
    if position?
      geo.addMap(GeoPosition.fromGeoLocations(position))


(exports ? this).PlayingsGeo = PlayingsGeo
