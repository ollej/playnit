class Uploader
  default_options:
    runtimes: "html5,flash,html4"
    chunk_size: 0
    max_image_size: "1mb"
    filters: [
      title: "Image files"
      extensions: "jpg,jpeg,gif,png"
    ]
    rename: true
    sortable: true
    autostart: true
    multi_selection: false
    multipart: true
    multipart_params:
      filename: "filename"
      utf8: true
    resize:
      width: 580
      height: 440
      quality: 90
      preserve_headers: true

  constructor: (options) ->
    logger.debug 'Uploader.constructor', options
    @options = _.extend({}, @default_options, options)
    unless (@fileApiAvailable())
      logger.warn 'File API not available'
      Flasher.warning('Photo uploads unavailable on this device.')
      $("#photo-group").hide()
      this
    @uploader = new plupload.Uploader(@options)
    @bindListeners()
    this

  fileApiAvailable: ->
    (window.File && window.FileReader && window.FileList && window.Blob)

  showPhoto: (location) ->
    logger.debug 'Uploader.showPhoto', location
    img = $('<img></img>')
      .prop('src', location)
      .prop('class', 'img-thumbnail')
    $("#photo").html(img)
    this

  addPhoto: (photo) ->
    logger.debug 'Uploader.addPhoto', photo
    $photo = $("<input>", {type:'hidden', name: "playing[remote_photo_url]", value: photo})
    $("#new_playing").append($photo)

  onFileUploaded: (up, file, response) ->
    logger.debug 'Uploader.onFileUploaded', up, file, response
    src = file.getSource()
    logger.debug 'Uploader.onFileUploaded file.src:', src

    result = @parseResponse(response.response)
    logger.debug 'Uploader.onFileUploaded parsed response:', result
    @showPhoto(result.location)
    @addPhoto(result.location)

  onImageLoaded: (img) ->
    logger.debug 'Uploader.onImageLoaded', img
    # TODO: Send img.meta.gps coords to GeoLocator object (via event?)
    logger.debug 'Uploader.onImageLoaded img.meta.gps:', img.meta.gps
    gps_data = img?.meta?.gps
    if gps_data
      @updateGPS(gps_data)

  updateGPS: (gps_data) ->
    logger.debug 'Uploader.updateGPS', gps_data
    pos = GeoPosition.fromGPS(gps_data)
    if pos.valid()

      # Ugly hack to insert positions in html
      $long = $('#playing_longitude')
      $lat = $('#playing_latitude')
      if !$long.val() && !$lat.val()
        $long.val(pos.long())
        $lat.val(pos.lat())
        Flasher.info('Got position from uploaded JPEG.')
        geo = new GeoDisplay "#map-edit"
        geo.addMap(pos)

  bindListeners: ->
    @uploader.bind "FilesAdded", (up, files) =>
      logger.debug 'Files added:', up, files
      $.each files, (i, file) =>
        logger.debug 'File added:', file
        moxieimg = new mOxie.Image()
        moxieimg.onload = =>
          @onImageLoaded(moxieimg)
        moxieimg.load(file.getSource())
      _.defer => up.start()

    @uploader.bind "BeforeUpload", (up, file) =>
      logger.debug 'event:BeforeUpload', file
      @setFilename(file)

    @uploader.bind 'FileUploaded', (up, file, response) =>
      logger.info 'event:FileUploaded', file, response
      @onFileUploaded(up, file, response)

    @uploader.bind 'UploadProgress', (up, file) =>
      logger.debug 'event:UploadProgress', file

    @uploader.bind 'Error', (up, err) =>
      logger.error 'event:UploadError', err

    this

  init: ->
    logger.debug 'Uploader.init'
    @uploader.init()
    this

  setFilename: (file) ->
    logger.debug 'Uploader.setFilename', file
    file.uniqueKey = ( "uploads/" + file.id + "/" + file.name )
    @uploader.settings.multipart_params.key = file.uniqueKey
    @uploader.settings.multipart_params.Filename = file.uniqueKey
    this

  parseResponse: (response) ->
    logger.debug 'Uploader.parseResponse', response
    result = {}
    pattern = /\<(Location|Bucket|Key)\>([^<]*)\<\/\1\>/gi
    matches = null
    while matches = pattern.exec(response)
      nodeName = matches[1].toLowerCase()
      nodeValue = matches[2]
      result[nodeName] = nodeValue
    result

(exports ? this).Uploader = Uploader
