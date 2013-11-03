class PlayingsGeo
  initGeo: ->
    if $("#map-edit").length > 0
      @initEdit()
    if $("#map-index").length > 0
      @initIndex()
    if $("#map-show").length > 0
      @initShow()

  initEdit: ->
    geo = new GeoLocator "#map-edit", (position) ->
      $('#playing_longitude').val(position.coords.longitude)
      $('#playing_latitude').val(position.coords.latitude)
    geo.locate();

  initIndex: ->
    geo = new GeoLocator "#map-index"
    geo.addMap(positions)

  initShow: ->
    geo = new GeoLocator "#map-show"
    geo.addMap([position])


(exports ? this).PlayingsGeo = PlayingsGeo
