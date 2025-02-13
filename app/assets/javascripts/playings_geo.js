class PlayingsGeo {
  initGeo() {
    logger.debug('PlayingsGeo.initGeo');
    if ($("#map-edit").length > 0) {
      this.initEdit('#map-edit');
    }
    if ($("#map-index").length > 0) {
      this.initIndex();
    }
    if ($("#map-show").length > 0) {
      this.initShow();
    }
  }

  initEdit(sel) {
    logger.debug('PlayingsGeo.initEdit', sel);
    if (this.hasPosition()) {
      const pos = GeoPosition.fromGeoPos(this.latitude(), this.longitude());
      new GeoDisplay(sel).addMap(pos);
      return;
    }

    if ($('#new-playing').length > 0) {
      const geo_locator = new GeoLocator(
        pos => this.displayMap(sel, pos),
        () => this.displayNoMap(sel)
      );
      geo_locator.locate();
    } else {
      new GeoDisplay(sel).addMapUnavailable();
    }
  }

  initIndex() {
    logger.debug('PlayingsGeo.initIndex');
    const geo = new GeoDisplay("#map-index");
    if (window.positions) {
      logger.debug('PlayingsGeo.initIndex has positions');
      geo.addMap(GeoPosition.fromGeoLocations(window.positions));
    }
  }

  initShow() {
    logger.debug('PlayingsGeo.initShow');
    const geo = new GeoDisplay("#map-show");
    if (window.position) {
      logger.debug('PlayingsGeo.initshow has position');
      geo.addMap(GeoPosition.fromGeoLocations(window.position));
    }
  }

  hasPosition() {
    if (this.longitude()) { return true; }
    if (this.latitude()) { return true; }
    return false;
  }

  longitude() {
    return $('#playing_longitude').val();
  }

  latitude() {
    return $('#playing_latitude').val();
  }

  displayMap(sel, positions) {
    logger.debug('PlayingsGeo.displayMap');
    new GeoDisplay(sel).addMap(positions);
    const position = positions[0];
    $('#playing_longitude').val(position.long());
    $('#playing_latitude').val(position.lat());
  }

  displayNoMap(sel) {
    logger.debug('PlayingsGeo.displayNoMap');
    new GeoDisplay(sel).addMapUnavailable();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).PlayingsGeo = PlayingsGeo;
