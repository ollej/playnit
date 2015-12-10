class Logger
  debug: -> @delegate 'debug', arguments

  warn: -> @delegate 'warn', arguments

  error: -> @delegate 'error', arguments

  info: -> @delegate 'info', arguments

  log: -> @delegate 'log', arguments

  delegate: (method, args) ->
    if @available(method)
      console[method].apply(console, args)
    else if @available('log')
      console['log'].apply(console, args)
    else
      return false

  available: (method) ->
    window && window.console && typeof window.console[method] == 'function'

(exports ? this).Logger = Logger
