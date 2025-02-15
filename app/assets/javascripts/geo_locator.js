class GeoLocator {
  constructor(success, fail, options = {}) {
    logger.debug('GeoLocator.constructor', options);
    this.success = success;
    this.fail = fail;
    this.options = Object.assign({}, options);
    // TODO: callback should be event
  }

  gotPosition(position) {
    logger.debug('GeoLocator.gotPosition', position);

    if (this.success) {
      const positions = GeoPosition.fromGeoLocations(position);
      this.success.call(this, positions);
    }
  }

  gotNoPosition(error) {
    FLASHER.warning("Failed to get position.");
    if (this.fail) {
      this.fail.call(this);
    }
  }

  locate() {
    if (navigator.geolocation) {
      logger.debug('GeoLocator.locate navigator.geolocation available');
      navigator.geolocation.getCurrentPosition(
        this.gotPosition.bind(this),
        this.gotNoPosition.bind(this));
    } else {
      FLASHER.warning('No geolocation available.');
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).GeoLocator = GeoLocator;
