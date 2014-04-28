class GameSelector
  constructor: (@sel = '.typeahead') ->
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

  abort: =>
    console.log "GameSelector.abort", @xhr
    @xhr.abort() if @xhr?

  # döda requests vid val
  # vänta x ms efter keystroke innan ny request
  # avbryta tidigare request vid ny, alt. inte göra ny request

(exports ? this).GameSelector = GameSelector
