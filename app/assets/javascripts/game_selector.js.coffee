class GameSelector
  constructor: (@sel = '.autocomplete') ->
    @$el = $(@sel)
    logger.debug "GameSelector.constructor", @sel, @$el
    @$el.autocomplete
      minLength: 3
      delay: 500
      source: @query
      select: @onSelect

  query: (query, process) =>
    logger.debug "GameSelector.query", query, process
    @callback = process
    @abort()
    @xhr = $.get '/game/index', { query: query['term'], format: 'json' }, @process

  process: (data, status, xhr) =>
    logger.debug "GameSelector.process", data, status, xhr
    @data = data
    @resetGame()
    @callback(data)

  resetGame: =>
    logger.debug "GameSelector.resetGame"
    $('#playing_bgg_id').val('')

  onSelect: (event, ui) =>
    logger.debug 'GameSelector.onSelect', event, ui
    @abort()
    logger.debug 'GameSelector.onSelect game:', $('#playing_game'), ui.item['label']
    logger.debug 'GameSelector.onSelect bgg_id:', $('#playing_bgg_id'), ui.item['value']
    bgg_id = ui.item['value']
    $('#playing_bgg_id').val(bgg_id)
    bgg_game = @getLabel(bgg_id)
    $('#playing_game').val(bgg_game?.name || ui.item['label'])

    return false

  abort: =>
    logger.debug "GameSelector.abort", @xhr
    @xhr.abort() if @xhr?

  getLabel: (bgg_id) =>
    logger.debug 'GameSelector.getLabel', bgg_id
    _.find @data, (game) -> game.value == bgg_id

(exports ? this).GameSelector = GameSelector
