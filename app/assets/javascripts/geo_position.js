class GeoPosition {
  constructor(position = {}) {
    logger.debug("GeoPosition.constructor", this.position);
    this.position = position;
  }

  long() {
    return this.position.coords.longitude;
  }

  lat() {
    return this.position.coords.latitude;
  }

  static fromGeoPos(lat, lng) {
    return new GeoPosition({
      coords: {
        latitude: lat,
        longitude: lng
      }
    });
  }

  static fromGeoLocations(geo_locations) {
    logger.debug('GeoPosition.fromGeoLocations', geo_locations);
    if (!Array.isArray(geo_locations)) { geo_locations = [geo_locations]; }
    return geo_locations.map((geo_location) => new GeoPosition(geo_location));
  }

  static fromGPS(gps) {
    logger.debug('GeoPosition.fromGPS', gps);
    const lat = GeoPosition.convertDMS(gps.GPSLatitude, gps.GPSLatitudeRef);
    const long = GeoPosition.convertDMS(gps.GPSLongitude, gps.GPSLongitudeRef);
    const position = {
      coords: {
        latitude: lat,
        longitude: long
      }
    };
    return new GeoPosition(position);
  }

  static convertDMS(dms, ref) {
    logger.debug('GeoPosition.convertDMS', dms, ref);
    const degrees = dms[0];
    const minutes = dms[1];
    const seconds = dms[2];

    let dd = degrees + (minutes / 60.0) + (seconds / (60.0 * 60.0));
    dd = parseFloat(dd);

    if ((ref === "S") || (ref === "W")) {
      dd = dd * -1.0;
    }

    logger.debug('GeoPosition.convertDMS result:', dd);
    return dd;
  }

  valid() {
    return this.position && this.position.coords && this.position.coords.latitude && this.position.coords.longitude;
  }

  toLatLng() {
    return new google.maps.LatLng(this.lat(), this.long());
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).GeoPosition = GeoPosition;
