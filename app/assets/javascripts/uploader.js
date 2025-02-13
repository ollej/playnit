class Uploader {
  constructor(options = {}) {
    logger.debug('Uploader.constructor', options);
    const default_options = {
      runtimes: "html5,flash,html4",
      chunk_size: 0,
      max_image_size: "1mb",
      filters: [{
        title: "Image files",
        extensions: "jpg,jpeg,gif,png"
      }
      ],
      rename: true,
      sortable: true,
      autostart: true,
      multi_selection: false,
      multipart: true,
      multipart_params: {
        filename: "filename",
        utf8: true
      },
      resize: {
        width: 580,
        height: 440,
        quality: 90,
        preserve_headers: true
      }
    };
    if (!this.fileApiAvailable()) {
      logger.warn('File API not available');
      FLASHER.warning('Photo uploads unavailable on this device.');
      $("#photo-group").hide();
      return;
    }
    const uploader_options = Object.assign({}, default_options, options);
    this.uploader = new plupload.Uploader(uploader_options);
    this.bindListeners();
  }

  fileApiAvailable() {
    return (window.File && window.FileReader && window.FileList && window.Blob);
  }

  showPhoto(location) {
    logger.debug('Uploader.showPhoto', location);
    const img = $('<img></img>')
      .prop('src', location)
      .prop('class', 'img-thumbnail');
    $("#photo").html(img);
  }

  addPhoto(photo) {
    logger.debug('Uploader.addPhoto', photo);
    const $photo = $("<input>", {type:'hidden', name: "playing[remote_photo_url]", value: photo});
    $("#new_playing").append($photo);
  }

  onFileUploaded(up, file, response) {
    logger.debug('Uploader.onFileUploaded', up, file, response);
    const src = file.getSource();
    logger.debug('Uploader.onFileUploaded file.src:', src);

    const result = this.parseResponse(response.response);
    logger.debug('Uploader.onFileUploaded parsed response:', result);
    this.showPhoto(result.location);
    this.addPhoto(result.location);
  }

  onImageLoaded(img) {
    logger.debug('Uploader.onImageLoaded', img);
    // TODO: Send img.meta.gps coords to GeoLocator object (via event?)
    if (img && img.meta && img.meta.gps) {
      this.updateGPS(img.meta.gps);
    }
  }

  updateGPS(gps_data) {
    logger.debug('Uploader.updateGPS', gps_data);
    const pos = GeoPosition.fromGPS(gps_data);
    if (pos.valid()) {
      // Ugly hack to insert positions in html
      const $long = $('#playing_longitude');
      const $lat = $('#playing_latitude');
      if (!$long.val() && !$lat.val()) {
        $long.val(pos.long());
        $lat.val(pos.lat());
        FLASHER.info('Got position from uploaded JPEG.');
        new GeoDisplay("#map-edit").addMap(pos);
      }
    }
  }

  bindListeners() {
    this.uploader.bind("FilesAdded", (up, files) => {
      var self = this;
      logger.debug('Files added:', up, files);
      $.each(files, (i, file) => {
        logger.debug('File added:', file);
        const moxieimg = new mOxie.Image();
        moxieimg.onload = () => {
          this.onImageLoaded(moxieimg);
        };
        moxieimg.load(file.getSource());
      });
      setTimeout(() => up.start(), 0);
    });

    this.uploader.bind("BeforeUpload", (up, file) => {
      logger.debug('event:BeforeUpload', file);
      this.setFilename(file);
    });

    this.uploader.bind('FileUploaded', (up, file, response) => {
      logger.info('event:FileUploaded', file, response);
      this.onFileUploaded(up, file, response);
    });

    this.uploader.bind('UploadProgress', (up, file) => {
      logger.debug('event:UploadProgress', file);
    });

    this.uploader.bind('Error', (up, err) => {
      logger.error('event:UploadError', err);
    });
  }

  init() {
    logger.debug('Uploader.init');
    this.uploader.init();
  }

  setFilename(file) {
    logger.debug('Uploader.setFilename', file);
    file.uniqueKey = ( "uploads/" + file.id + "/" + file.name );
    this.uploader.settings.multipart_params.key = file.uniqueKey;
    this.uploader.settings.multipart_params.Filename = file.uniqueKey;
  }

  parseResponse(response) {
    logger.debug('Uploader.parseResponse', response);
    const result = {};
    const pattern = /\<(Location|Bucket|Key)\>([^<]*)\<\/\1\>/gi;
    let matches = null;
    while ((matches = pattern.exec(response))) {
      const nodeName = matches[1].toLowerCase();
      const nodeValue = matches[2];
      result[nodeName] = nodeValue;
    }
    return result;
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Uploader = Uploader;
