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
    multipart: true
    multipart_params:
      filename: "filename"
      utf8: true
    resize:
      width: 640
      height: 480
      quality: 90

  constructor: (options) ->
    @options = _.extend({}, @default_options, options)
    @uploader = new plupload.Uploader(@options)
    @bindListeners()
    this

  bindListeners: ->
    @uploader.bind "FilesAdded", (up, files) =>
      console.log 'Files added:', up, files
      $.each files, (i, file) =>
        console.log 'File added:', file
      _.defer => up.start()

    @uploader.bind "BeforeUpload", (up, file) =>
      @setFilename(file)

    @uploader.bind 'FileUploaded', (up, file, response) =>
      console.log 'File uploaded!', up, file, response
      src = file.getSource()
      console.log('src', src)
      result = @parseResponse(response.response)
      console.log("result", result)
      img = $('<img></img>')
        .prop('src', result.location)
        .prop('class', 'img-polaroid')
      $("#photo").prepend(img)

    @uploader.bind 'UploadProgress', (up, file) =>
      console.log 'Upload progress:', up, file

    @uploader.bind 'Error', (up, err) =>
      console.log 'Upload Error', up, err

    this

  init: ->
    @uploader.init()
    this

  setFilename: (file) ->
    uniqueKey = ( "uploads/" + file.id + "/" + file.name );
    @uploader.settings.multipart_params.key = uniqueKey;
    @uploader.settings.multipart_params.Filename = uniqueKey; 

  parseResponse: (response) ->
    console.log('response', response)
    result = {}
    pattern = /\<(Location|Bucket|Key)\>([^<]*)\<\/\1\>/gi
    matches = null
    while matches = pattern.exec(response)
      nodeName = matches[1].toLowerCase()
      nodeValue = matches[2]
      result[nodeName] = nodeValue
    result

(exports ? this).Uploader = Uploader
