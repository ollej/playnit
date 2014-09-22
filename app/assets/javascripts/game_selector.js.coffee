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
    @data = data
    @resetGame()
    @callback(data)

  resetGame: =>
    $('#playing_game').val('')
    $('#playing_bgg_id').val('')

  onSelect: (event, ui) =>
    console.log "GameSelector.onSelect", event, ui
    @abort()
    console.log $('#playing_game'), ui.item['label']
    console.log $('#playing_bgg_id'), ui.item['value']
    bgg_id = ui.item['value']
    $('#playing_bgg_id').val(bgg_id)
    bgg_game = @getLabel(bgg_id)
    $('#playing_game').val(bgg_game?.name || ui.item['label'])

    return false

  abort: =>
    console.log "GameSelector.abort", @xhr
    @xhr.abort() if @xhr?

  getLabel: (bgg_id) =>
    console.log "getLabel", bgg_id
    _.find @data, (game) -> game.value == bgg_id

(exports ? this).GameSelector = GameSelector
