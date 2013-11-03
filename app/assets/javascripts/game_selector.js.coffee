class GameSelector
  query: (query, process) =>
    callback = (data, status, xhr) => process(data)
    $.get '/game/index', { query: query, format: 'json' }, callback

  staticquery: =>
    ["Fluxx", "Aquarius", "Tsuro"]

(exports ? this).GameSelector = GameSelector
