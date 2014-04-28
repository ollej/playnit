$(document).ready =>
  console.log('playings ready')
  new PlayingsGeo().initGeo()
  gamesel = new GameSelector()

  if $("#uploader").length > 0
    console.log('window.uploader_options', window.uploader_options)
    new Uploader(window.uploader_options).init()
