class Flixpot.Managers.TvSeasons extends SimPL.Manager
  endpoint: '/season'
  collectionItemTemplate: 'seasons_collection'
  collectionContainer: '#seasons-collection'
  jsonItemContainer: ''
  fixedOptions:
    api_key: '300d2fb47e3f5f8d5e569ce27884acdc'
    include_adult: false

  collectionEvents:
    'click': 'clickItem'

  renderIf: (item) =>
    if moment(item.air_date).isAfter(moment()) or item.season_number == 0 or item.episode_count == 0 or not item.air_date
      return false
    return true

  #beforeRender: ($el, item) ->
  #  if moment(item.air_date).isAfter(moment()) or item.season_number == 0
  #    $el.hide()

  clickItem: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()

    cItem = evt.data.item
    cItem.addChild('episodes', new Flixpot.Managers.TvEpisodes())

    @find evt.data.item.season_number, (item) =>

      $('#nav-title').text('Season ' + item.season_number + ' Episodes')
      window.navStatus = 2

      cItem.episodes.setCollection item.episodes, () =>
        cItem.episodes.showCollection()
        #$(@collectionContainer).hide()
        #$(cItem.episodes.collectionContainer).show()
        $('.nav-slider').slickNext()
        $('html, body').animate({scrollTop: 0}, 0)
