class Flixpot.Managers.Movies extends SimPL.Manager
  endpoint: 'http://api.themoviedb.org/3/movie'
  collectionItemTemplate: 'movies_collection'
  #collectionFetchTemplate: 'fetch'
  itemTemplate: 'movies_item'
  collectionContainer: '#movies-collection'
  itemContainer: '#movie-info-popup'
  jsonCollectionContainer: 'results'
  jsonItemContainer: ''
  fixedOptions:
    api_key: '300d2fb47e3f5f8d5e569ce27884acdc'
    include_adult: false

  constructor: () ->
    #

  collectionEvents:
    'click .js-btn-info': 'clickInfoLink'
    'click': 'clickItem'

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
          src: '#movie-info-popup'
          type: 'inline'
        mainClass: 'mfp-zoom-in'
        removalDelay: 300

  clickItem: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/spots/new?tmdb_id=' + encodeURIComponent(evt.data.item.id) + '&media_item_title=' + encodeURIComponent(evt.data.item.title) + '&category=0'


  afterRender: ($el) ->
    #

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
