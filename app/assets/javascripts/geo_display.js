class GeoDisplay {
  constructor(sel, options = {}) {
    this.div = Dom.q(sel);
    logger.debug('GeoDisplay.constructor', sel, options, this.div);
    this.width = 640;
    this.height = 480;
    this.latlngs = [];
    this.map = {};
    const default_options = {
      mapTypeControl: false,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.SMALL
      },
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    this.options = Object.assign({}, default_options, options);
  }

  addMapUnavailable() {
    logger.debug('GeoDisplay.addMapUnavailable');
    this.div.html("<div class='map-unavailable'></div>");
  }

  addMap(positions) {
    logger.debug('GeoDisplay.addMap positions:', positions);
    if (!Array.isArray(positions)) { positions = [positions]; }
    logger.debug('GeoDisplay.addMap positions wrapped:', positions);
    if ((positions.length === 1) && !positions[0].valid()) {
      logger.warn('GeoDisplay.addMap - Position is invalid');
      this.addMapUnavailable();
      return;
    }
    this.addEmptyMap();
    logger.debug('GeoDisplay.addMap @map', this.map);
    if (positions.length === 1) {
      this.map.setCenter(positions[0].toLatLng());
      this.map.setZoom(15);
    } else {
      this.setBounds(positions);
    }
    this.addPositionsAsMarkers(positions);
  }

  setBounds(positions) {
    logger.debug('GeoDisplay.setBounds', positions);
    const latlngbounds = new google.maps.LatLngBounds();
    for (var position of positions) {
      var latlng = position.toLatLng();
      logger.debug('GeoDisplay.setBounds position', position, latlng);
      latlngbounds.extend(latlng);
    }
    this.map.setCenter(latlngbounds.getCenter());
    this.map.fitBounds(latlngbounds);
  }

  addPositionsAsMarkers(positions) {
    logger.debug('GeoDisplay.addPositionsAsMarkers', positions);
    for (const position of positions) {
      if (position.valid()) {
        const latlng = position.toLatLng();
        this.addMarker(latlng);
      }
    }
  }

  addEmptyMap() {
    logger.debug('GeoDisplay.addEmptyMap');
    const mapDiv = Dom.create('div', {
      id: 'mapcanvas',
      width: this.width,
      height: this.height
    });
    logger.debug('GeoDisplay.addEmptyMap @options', this.options);
    const options = Object.assign({}, this.options);
    this.map = new google.maps.Map(mapDiv.el, options);
    this.div.replace(mapDiv);
  }

  addMarker(latlng) {
    if (!this.map) { return; }
    logger.debug('GeoDisplay.addMarker', latlng);
    const marker = new google.maps.Marker({
      position: latlng,
      map: this.map,
      title: "You are here!"
    });
    this.latlngs.push(latlng);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).GeoDisplay = GeoDisplay;
