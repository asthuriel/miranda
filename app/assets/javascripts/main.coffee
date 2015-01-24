$(()->
  moment.locale('en')

  $('.js-submenu-link').click (evt) ->
    evt.preventDefault()
    $(@).parent().find('.submenu').slideDown(50)

  $(document).mousedown (evt) ->
    container = $('.submenu')
    if (not container.is(evt.target)) and (container.has(evt.target).length is 0)
      container.slideUp(50)

  $(document).scroll (evt) ->
    $('.submenu').slideUp(50)

  $(window).scroll () ->
    if $('#nav').hasClass('js-nav-dual')
      if $(@).scrollTop() > 20
        $('#nav').removeClass('nav--alternate')
      else
        $('#nav').addClass('nav--alternate')

  $('#nav-back').click (evt) ->
    history.back()

  $('a[href="#"]').click (evt) ->
    evt.preventDefault()

  $('.js-autosize').autosize(
    append: false
    placeholder: true
  )

  ###if $('.js-select2').length
    $('.js-select2').select2(
      placeholder: "Add some friends here!"
      minimumInputLength: 1
      formatInputTooShort: () ->
        return ''
    )
    $('.js-select2').removeClass('hidden')###
)
