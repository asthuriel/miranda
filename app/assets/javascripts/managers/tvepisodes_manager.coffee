class Flixpot.Managers.TvEpisodes extends SimPL.Manager
  endpoint: '/episode'
  collectionItemTemplate: 'episodes_collection'
  collectionContainer: '#episodes-collection'
  jsonItemContainer: ''
  fixedOptions:
    api_key: '300d2fb47e3f5f8d5e569ce27884acdc'
    include_adult: false

  collectionEvents:
    'click .js-btn-info': 'clickInfo'
    'click': 'clickItem'

  renderIf: (item) =>
    if moment(item.air_date).isAfter(moment())
      return false
    return true

  clickInfo: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()

    cItem = evt.data.item
    cItem['__simpl__'].$el.find('.js-episode-overview').toggleClass('clamp-2')

  clickItem: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    newLocation = ''
    newLocation += '/spots/new?tmdb_id=' + encodeURIComponent(evt.data.item.id)
    newLocation += '&media_item_title=' + encodeURIComponent(evt.data.item.name) + '&category=2'
    newLocation += '&series_id=' + encodeURIComponent(window.currentSeriesId)
    newLocation += '&season_number=' + encodeURIComponent(evt.data.item.season_number)
    newLocation += '&episode_number=' + encodeURIComponent(evt.data.item.episode_number)
    window.location.href = newLocation

  #beforeRender: ($el, item) ->
  #  if moment(item.air_date).isAfter(moment())
  #    $el.hide()
