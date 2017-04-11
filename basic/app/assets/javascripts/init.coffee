window.App ||= {}

App.flash_snackbar_render = (flashMessages) ->
  $.each flashMessages, (key, value) ->
    style = ''
    switch key
      when 'success'
        style = 'callout callout-success'
      when 'danger'
        style = 'callout callout-danger'
      when 'error'
        style = 'callout callout-danger'
      else
        style = 'callout'
        break
    $.snackbar
      content: value
      style: style
      timeout: 10000
    return
  return

App.initSnackbar = ->
  if $('.snackbar-message').length > 0
    $('.snackbar-message').snackbar 'show'

App.initDatepicker = ->
  if $('.datepicker').length > 0
    $('.datepicker').datetimepicker
      icons:
        time: 'fa fa-clock-o'
        date: 'fa fa-calendar'
        up: 'fa fa-chevron-up'
        down: 'fa fa-chevron-down'
        previous: 'fa fa-chevron-left'
        next: 'fa fa-chevron-right'
        today: 'fa fa-bullseye'
        clear: 'fa fa-trash'
        close: 'fa fa-remove'
      format: 'MM/DD/YYYY'
      locale: 'en'

# Inicializa los modals con ajax
App.initModals = (parent) ->
  if parent
    links = parent.find('[data-behavior~=ajax-modal]')
  else
    links = $('[data-behavior~=ajax-modal]')

  links.on 'click', (e)->
    that = this
    e.preventDefault()
    e.stopPropagation()
    $.ajax
      url: this.href
    .done (data)->
      modal = $(that.getAttribute('data-target'))
      modal.addClass(that.getAttribute('data-targetClass'))
      modal.find('.modal-content').html(data)
      modal.modal("show");
      App.initTooltips(modal)

    return

App.show_form_error_messages = (modelName, form, error_messages) ->
  # If there are errors in actual form, removes them
  formsWithErrors = $(form).find('div.form-group.has-error')
  formsWithErrors.children('span.help-block').remove()
  formsWithErrors.children().unwrap()
  $(form).find('div.text-danger').children().unwrap()

  # Show new errors
  for key, value of error_messages
    # key maps with the element that triggers the event, it has the attribute name="model[key]"
    # value is an array of error messages from that field
    element = $(form).find("[name='#{modelName.toLowerCase()}[#{key}]']")
    label = $(form).find("label[for='#{element.attr('id')}']")

    element.wrap("<div class='form-group has-error'></div>")
    element.after("<span class='help-block'>&nbsp;#{value.join(', ')}</span>")

    label.wrap("<div class='text-danger'></div>")

App.initTooltips = (parent) ->
  elements = if parent then parent.find("a, span, i, div, td, h5") else $("a, span, i, div, td, h5")
  elements.tooltip()

App.init = ->
  # Snackbar
  App.initSnackbar()

  # Datepicker
  App.initDatepicker()

  # Ajax Modals
  App.initModals()

  $("a, span, i, div, td, h5").tooltip()

  # Select2
  $("normal-select2").normalSelect()

  $('.sidebar li.active').closest('.treeview').addClass('active')

$(document).on "turbolinks:load", ->
  App.init()

$(document).on "turbolinks:request-end", ->
  App.initSnackbar()
  App.initModals()
  App.initDatepicker()
  $("normal-select2").normalSelect()

$(document).on 'flash:send', (e, flashMessages) ->
  App.flash_snackbar_render flashMessages
  return
