$(document).ready =>
  new PlayingsGeo().initGeo()
  $(".typeahead").typeahead
    source: (query, process) -> 
      console.log('hi')
      sel = new GameSelector()
      sel.query(query, process)
    minLength: 2

