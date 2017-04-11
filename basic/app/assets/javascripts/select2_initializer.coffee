jQuery.fn.ajaxSelect = (options) ->
  url = $(this).data('url')
  $select = $(this)

  defaults =
    placeholder: "Search..."
    allow_clear: true
    createSearchChoicePosition: 'bottom'
    createSearchChoice: () -> false
    formatter: (record) ->
      record.full_text || record.name
    result_formatter: (record, container, query, escapeMarkup) ->
      markup = []
      text = settings.format_name(record)
      Select2.util.markMatch(text, query.term, markup, escapeMarkup)
      markup = markup.join("")
      markup = "<div class='select2-main-text'> #{markup} </div>"
      if record.extra
        markup += settings.format_extra(record)

      return markup
    format_name: (record) ->
      record.full_text || record.name
    format_extra: (record) ->
      return "<small class='select2-extra-text'> #{record.extra} </small>"

    selectData: (params)->
      query: params.term
      limit: 10
      page: params.page

  settings = $.extend(defaults, options)

  $option = $("<option selected>#{$(this).data('record-text')}</option>").val($(this).data('record-id'))
  $select.append($option).trigger('change')

  this.select2
    placeholder: settings.placeholder
    allowClear: settings.allow_clear
    minimumInputLength: 2
    ajax:
      url: url
      delay: 250
      data: (term, page) ->
        settings.selectData(term, page)
      results: (data, page) ->
        more = (page * 10) < data.total

        results: data.records
        more: more
    formatResult: settings.result_formatter
    formatSelection: settings.formatter
    createSearchChoice: settings.createSearchChoice
    createSearchChoicePosition: settings.createSearchChoicePosition
    createSearchChoice: settings.createSearchChoice



jQuery.fn.normalSelect = (options) ->
  defaults =
    placeholder: 'Search...'
    allowClear: true
    escapeMarkup: (m) -> m
    formatNoMatches: 'No results found'
    formatSearching: "Searching..."
    formatAjaxError: 'Loading failed'
    formatInputTooShort: (term, minimum)->
      "Please insert at least #{minimum} characters"

  settings = $.extend(defaults, options)
  $(this).select2 settings
