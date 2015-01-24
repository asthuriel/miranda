$(()->
  window.seriesName = ''
  window.navStatus = 0

  tvShows = new Flixpot.Managers.TvShows()
  searching = false

  refreshResults = (searchString) ->
    if searchString.length >= 3
      searching = true
      $('#search-input__loading').show()
      tvShows.withEndpoint('http://api.themoviedb.org/3/search/tv').fetch ->
        $('#search-input__loading').hide()
        tvShows.showCollection()
        $('.nav-slider').slickGoTo(0)
        $('html, body').animate({scrollTop: 0}, 'fast')
      , {query: searchString, search_type: 'ngram'}

    else if searchString == ''
      searching = false
      $('#search-input__loading').show()
      tvShows.fetch () ->
        $('#search-input__loading').hide()
        tvShows.showCollection()
        $('.nav-slider').slickGoTo(0)
      , {}, 'popular'

  searchInput = new Flixpot.Modules.SearchInput({
    placeholder: "Search..."
    refreshResults: refreshResults
  })

  refreshResults('')

  $(window).scroll ()->
    if ($(window).scrollTop() + $(window).height() == $(document).height()) and (window.navStatus is 0) and (not searching)
      tvShows.fetchMore ->
        tvShows.appendNew()
        $('.nav-slider').slickGoTo(0)
      , {}, 'popular'

  $('#nav-back-return').click () ->
    if window.navStatus is 2
      #$('#episodes-collection').hide()
      #$('#seasons-collection').show()
      $('.nav-slider').slickPrev()
      $('#nav-title').text(window.seriesName)
      $('html, body').animate({scrollTop: 0}, 0)
      window.navStatus = 1
    else if window.navStatus is 1
      #$('#seasons-collection').hide()
      #$('#tvshows-collection').show()
      $('.nav-slider').slickPrev()
      $('#nav-content-navigation').hide()
      $('#nav-content-main').show()
      $('html, body').animate({scrollTop: 0}, 0)
      window.navStatus = 0

  $('.nav-slider').slick
    accessibility: false
    autoplay: false
    arrows: false
    dots: false
    draggable: false
    infinite: false
    speed: 200
    swipe: false
    slidesToShow: 1
    adaptiveHeight: true
)

