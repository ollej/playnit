Dom.ready(() => {
  logger.info('Playings page');
  new PlayingsGeo().initGeo();
  new GameSelector();

  if (Dom.id("uploader")) {
    logger.debug('Creating Uploader with options:', window.uploader_options);
    new Uploader(window.uploader_options).init();
  }
});
