class PlayingsGeo {
  initGeo() {
    logger.debug('PlayingsGeo.initGeo');
    if (Dom.id("map-edit")) {
      this.initEdit('#map-edit');
    }
    if (Dom.id("map-index")) {
      this.initIndex();
    }
    if (Dom.id("map-show")) {
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

    if (Dom.id('new-playing')) {
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
    } else {
      logger.debug("No position available");
      geo.addMapUnavailable();
    }
  }

  hasPosition() {
    if (this.longitude()) { return true; }
    if (this.latitude()) { return true; }
    return false;
  }

  longitude() {
    return Dom.id('playing_longitude').val();
  }

  latitude() {
    return Dom.id('playing_latitude').val();
  }

  displayMap(sel, positions) {
    logger.debug('PlayingsGeo.displayMap');
    new GeoDisplay(sel).addMap(positions);
    const position = positions[0];
    logger.debug("PlayingsGeo.displayMap position=", position);
    Dom.id('playing_longitude').val(position.long());
    Dom.id('playing_latitude').val(position.lat());
  }

  displayNoMap(sel) {
    logger.debug('PlayingsGeo.displayNoMap');
    new GeoDisplay(sel).addMapUnavailable();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).PlayingsGeo = PlayingsGeo;
