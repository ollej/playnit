$(document).ready =>
  new PlayingsGeo().initGeo()
  $(".typeahead").typeahead
    minLength: 3
    source: (query, process) -> 
      sel = new GameSelector()
      sel.query(query, process)

  if $("#uploader").length > 0
    console.log('window.uploader_options', window.uploader_options)
    new Uploader(window.uploader_options).init()
