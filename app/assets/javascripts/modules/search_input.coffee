class Flixpot.Modules.SearchInput
  $el: null
  visible: false

  constructor: (options) ->
    placeholder = 'Search...'
    containerId = '#nav-content-search'
    if options
      placeholder = options.placeholder ? placeholder
      @refreshResults = options.refreshResults ? @refreshResults
    @$el = $(SimPL.Config.applyTemplate('search_input', {placeholder: placeholder}))

    if $(containerId).length
      $(containerId).append(@$el)
      @visible = true

    if@visible
      @bindFunctions()

  refreshResults: (val) ->
    console.log val

  delay = (->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
      true
  )()

  bindFunctions: () ->
    refreshResults = @refreshResults

    $('#search-input__clear').find('a').click (evt) ->
      evt.preventDefault()
      if $('#search-input').val() != ''
        $('#search-input').val('')
        refreshResults('')

    $('#nav-back-cancel').click (evt) ->
      evt.preventDefault()
      $('#nav-content-standard').show()
      $('#nav-content-search').hide()
      if $('#search-input').val() != ''
        $('#search-input').val('')
        refreshResults('')

    $('#nav-search').click (evt) ->
      evt.preventDefault()
      $('#nav-content-standard').hide()
      $('#nav-content-search').show()
      $('#search-input').focus()

    $('#search-input').keyup (evt) ->
      val = $(@).val()
      if val.length > 0
        $('#search-input__clear').show()
      else
        $('#search-input__clear').hide()
      delay (->
        refreshResults(val)
        true
      ), 300
      true







