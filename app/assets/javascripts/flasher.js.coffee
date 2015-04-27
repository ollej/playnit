class Flasher
  constructor: (@sel) ->

  div: ->
    if @$div?
      return @$div
    @$div = $(@sel)
    @$div

  flash: (msg, level = "danger") ->
    console.log('flash', msg, level)
    @div().append("<div class='alert fade in alert-#{level}'><button class='close' data-dismiss='alert'>×</button>#{msg}</div>")

  warning: (msg) -> @flash(msg, 'warning')
  error: (msg) -> @flash(msg, 'danger')
  info: (msg) -> @flash(msg, 'info')
  success: (msg) -> @flash(msg, 'success')
  clear: -> @div().html('')

(exports ? this).Flasher = Flasher
