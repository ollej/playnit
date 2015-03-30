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
    @options = _.extend({}, @default_options, options)
    unless (@fileApiAvailable())
      console.log('no file api')
      Flasher.warning('Photo uploads unavailable on this device.')
      $("#photo-group").hide()
      this
    @uploader = new plupload.Uploader(@options)
    @bindListeners()
    this

  fileApiAvailable: ->
    (window.File && window.FileReader && window.FileList && window.Blob)

  showPhoto: (location) ->
    img = $('<img></img>')
      .prop('src', location)
      .prop('class', 'img-polaroid')
    $("#photo").html(img)
    this

  addPhoto: (photo) ->
    $photo = $("<input>", {type:'hidden', name: "playing[remote_photo_url]", value: photo})
    $("#new_playing").append($photo)

  onFileUploaded: (up, file, response) ->
    #console.log 'File uploaded!', up, file, response
    src = file.getSource()
    #console.log('src', src)

    result = @parseResponse(response.response)
    #console.log("result", result)
    @showPhoto(result.location)
    @addPhoto(result.location)

  onImageLoaded: (img) ->
    #console.log('onImageLoaded', img)
    # TODO: Send img.meta.gps coords to GeoLocator object (via event?)
    console.log(img.meta.gps)
    pos = GeoPosition.fromGPS(img.meta.gps)
    # Ugly hack to insert positions in html
    $long = $('#playing_longitude')
    $lat = $('#playing_latitude')
    if !$long.val() && !$lat.val()
      $long.val(pos.long())
      $lat.val(pos.lat())

  bindListeners: ->
    @uploader.bind "FilesAdded", (up, files) =>
      #console.log 'Files added:', up, files
      $.each files, (i, file) =>
        #console.log 'File added:', file
        moxieimg = new mOxie.Image()
        moxieimg.onload = =>
          @onImageLoaded(moxieimg)
        moxieimg.load(file.getSource())
      _.defer => up.start()

    @uploader.bind "BeforeUpload", (up, file) =>
      console.log('beforeupload', file)
      @setFilename(file)

    @uploader.bind 'FileUploaded', (up, file, response) =>
      @onFileUploaded(up, file, response)

    @uploader.bind 'UploadProgress', (up, file) =>
      #console.log 'Upload progress:', up, file

    @uploader.bind 'Error', (up, err) =>
      #console.log 'Upload Error', up, err

    this

  init: ->
    @uploader.init()
    this

  setFilename: (file) ->
    file.uniqueKey = ( "uploads/" + file.id + "/" + file.name )
    @uploader.settings.multipart_params.key = file.uniqueKey
    @uploader.settings.multipart_params.Filename = file.uniqueKey
    this

  parseResponse: (response) ->
    #console.log('response', response)
    result = {}
    pattern = /\<(Location|Bucket|Key)\>([^<]*)\<\/\1\>/gi
    matches = null
    while matches = pattern.exec(response)
      nodeName = matches[1].toLowerCase()
      nodeValue = matches[2]
      result[nodeName] = nodeValue
    result

(exports ? this).Uploader = Uploader
