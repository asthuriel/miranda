$(()->
  movies = new Flixpot.Managers.Movies()
  searching = false

  refreshResults = (searchString) ->
    if searchString.length >= 3
      searching = true
      $('#search-input__loading').show()
      movies.withEndpoint('http://api.themoviedb.org/3/search/movie').fetch ->
        $('#search-input__loading').hide()
        movies.showCollection()
        $('html, body').animate({scrollTop: 0}, 'fast')
      , {query: searchString, search_type: 'ngram'}
    else if searchString == ''
      searching = false
      $('#search-input__loading').show()
      movies.fetch ->
        $('#search-input__loading').hide()
        movies.showCollection()
      , {}, 'now_playing'

  searchInput = new Flixpot.Modules.SearchInput({
    placeholder: "Search..."
    refreshResults: refreshResults
  })

  refreshResults('')

  $(window).scroll ()->
    if ($(window).scrollTop() + $(window).height() == $(document).height()) and (not searching)
      movies.fetchMore ->
        movies.appendNew()
      , {}, 'now_playing'
)
