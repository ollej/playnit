$(document).ready =>
  new PlayingsGeo().initGeo()
  $(".typeahead").typeahead
    minLength: 3
    source: (query, process) -> 
      sel = new GameSelector()
      sel.query(query, process)

