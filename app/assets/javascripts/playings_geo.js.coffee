class PlayingsGeo
  initGeo: ->
    if $("#map-edit").length > 0
      @initEdit('#map-edit')
    if $("#map-index").length > 0
      @initIndex()
    if $("#map-show").length > 0
      @initShow()

  initEdit: (sel) ->
    if @hasPosition()
      pos = GeoPosition.fromGeoPos(@latitude(), @longitude())
      geo_map = new GeoDisplay(sel)
      geo_map.addMap(pos)
    else
      if $('#new-playing').length > 0
        geo_locator = new GeoLocator(
          (pos) => @displayMap(sel, pos),
          => @displayNoMap(sel)
        )
        geo_locator.locate()
      else
        geo_map = new GeoDisplay(sel)
        geo_map.addMapUnavailable()

  initIndex: ->
    geo = new GeoDisplay "#map-index"
    if positions?
      geo.addMap(GeoPosition.fromGeoLocations(positions))

  initShow: ->
    geo = new GeoDisplay "#map-show"
    if position?
      geo.addMap(GeoPosition.fromGeoLocations(position))

  hasPosition: ->
    return true if @longitude()
    return true if @latitude()
    return false

  longitude: ->
    $('#playing_longitude').val()

  latitude: ->
    $('#playing_latitude').val()

  displayMap: (sel, positions) ->
    geo_map = new GeoDisplay(sel)
    geo_map.addMap(positions)
    position = positions[0]
    $('#playing_longitude').val(position.long)
    $('#playing_latitude').val(position.lat)

  displayNoMap: (sel) ->
    geo_map = new GeoDisplay(sel)
    geo_map.addMapUnavailable()

(exports ? this).PlayingsGeo = PlayingsGeo
