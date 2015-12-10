$(document).ready =>
  logger.info 'Playings page'
  new PlayingsGeo().initGeo()
  gamesel = new GameSelector()

  if $("#uploader").length > 0
    logger.debug 'Creating Uploader with options:', window.uploader_options
    new Uploader(window.uploader_options).init()
