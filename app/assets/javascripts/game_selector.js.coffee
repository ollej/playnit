class GameSelector
  constructor: (@sel = '.autocomplete') ->
    @$el = $(@sel)
    console.log "GameSelector.setup", @$el
    @$el.autocomplete
      minLength: 3
      delay: 500
      source: @query
      select: @onSelect

  query: (query, process) =>
    console.log "GameSelector.query", query, process
    @callback = process
    @abort()
    @xhr = $.get '/game/index', { query: query['term'], format: 'json' }, @process

  process: (data, status, xhr) =>
    console.log "GameSelector.process", data, status, xhr
    @callback(data)

  onSelect: (event, ui) =>
    console.log "GameSelector.onSelect", event, ui
    @abort()
    console.log $('#playing_game'), ui.item['label']
    console.log $('#playing_bgg_id'), ui.item['value']
    $('#playing_game').val(ui.item['label'])
    $('#playing_bgg_id').val(ui.item['value'])
    return false
    

  abort: =>
    console.log "GameSelector.abort", @xhr
    @xhr.abort() if @xhr?

(exports ? this).GameSelector = GameSelector
