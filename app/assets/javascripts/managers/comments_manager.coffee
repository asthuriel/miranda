class Flixpot.Managers.Comments extends SimPL.Manager
  endpoint: '/api/comments'
  collectionItemTemplate: 'comments_collection'
  #collectionEmptyTemplate: 'comments_empty'
  collectionFetchTemplate: 'fetch'
  collectionContainer: '#comments'
  onAdd: 'append'

  collectionRendered: false

  collectionEvents:
    'click .js-user-link': 'goToUser'

  goToUser: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.user.username

  beforeRender: ($el) ->
    if @collectionRendered
      $el.hide()

  afterRender: ($el) ->
    if @collectionRendered
      $('html, body').animate({scrollTop: $(document).height()}, 'fast')
      $el.slideDown(100)

  afterCollectionShow: () ->
    @collectionRendered = true




