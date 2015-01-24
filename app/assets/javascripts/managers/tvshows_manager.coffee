class Flixpot.Managers.TvShows extends SimPL.Manager
  endpoint: 'http://api.themoviedb.org/3/tv'
  collectionItemTemplate: 'tvshows_collection'
  itemTemplate: 'tvshows_item'
  itemContainer: '#tvshow-info-popup'
  collectionContainer: '#tvshows-collection'
  jsonCollectionContainer: 'results'
  jsonItemContainer: ''
  fixedOptions:
    api_key: '300d2fb47e3f5f8d5e569ce27884acdc'
    include_adult: false

  collectionEvents:
    'click .js-btn-info': 'clickInfoLink'
    'click': 'clickItem'

  renderIf: (item) =>
    if moment(item.first_air_date).isAfter(moment()) or not item.first_air_date
      return false
    return true

  getCast: (cItem) ->
    @find cItem.id, (item) =>
      cast = item.cast
      castString = ''
      if not cast.blank()
        castLength = if cast.length < 3 then cast.length else 3
        for inx in [0..castLength]
          member = cast[inx]
          if member
            castString += member.name + ', '
        castString = castString.substring(0, castString.length - 2)
        castString += '.'
      cItem.set('cast', castString)
    , 'credits'

  afterFetch: (collection) ->
    for cItem in collection
      @getCast(cItem)

  clickInfoLink: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()

    @find evt.data.item.id, (item) =>
      @showItem()
      if item.backdrop_path
        img = new Image()
        img.onload = () ->
          $img = $(img)
          $img.hide().appendTo('#js-backdrop').fadeIn('fast')
        img.src = 'http://image.tmdb.org/t/p/w780/' + item.backdrop_path

      $.magnificPopup.open
        items:
          src: '#tvshow-info-popup'
          type: 'inline'
        mainClass: 'mfp-zoom-in'
        removalDelay: 300

  clickItem: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()

    cItem = evt.data.item
    cItem.addChild('seasons', new Flixpot.Managers.TvSeasons())

    @find cItem.id, (item) =>
      $('#nav-content-main').hide()
      $('#nav-title').text(item.name)
      window.seriesName = item.name
      window.navStatus = 1
      window.currentSeriesId = item.id
      $('#nav-content-navigation').show()

      cItem.seasons.setCollection item.seasons, () =>
        cItem.seasons.showCollection()
        #$(@collectionContainer).hide()
        #$(cItem.seasons.collectionContainer).show()
        $('.nav-slider').slickNext()
        $('html, body').animate({scrollTop: 0}, 0)
