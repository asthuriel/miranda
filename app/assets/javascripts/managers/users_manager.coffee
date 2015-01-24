class Flixpot.Managers.Users extends SimPL.Manager
  endpoint: '/api/users'
  collectionItemTemplate: 'users_collection'
  collectionEmptyTemplate: 'users_empty'
  collectionContainer: '#users'

  collectionEvents:
    'click .js-btn-add': 'clickTagAlongUser'
    'click .js-user-link': 'goToUser'

  goToUser: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.username

  tagAlongs: null

  constructor: () ->
    @tagAlongs = new Flixpot.Managers.TagAlongs()

  clickTagAlongUser: (evt) =>
    evt.preventDefault()
    if evt.data.item.tag_id
      @tagAlongs.destroy evt.data.item.tag_id, (success) ->
        if success
          evt.data.item['__simpl__'].$el.slideUp 'fast', () ->
            evt.data.item['__simpl__'].$el.remove()
        else
          console.log 'pava' #REFACTOR!!!
    else
      newTagItem =
        tagger_id: parseInt($('#user_id').val())
        tagged_id: evt.data.item.id
      @tagAlongs.addItem newTagItem, (success) =>
        if success
          evt.data.item['__simpl__'].$el.slideUp 'fast', () ->
            evt.data.item['__simpl__'].$el.remove() #REFACTOR!!! (el remove del DOM debería estar dentro de Simpl, como item remove o algo asi, ya que aqui esta quedando el item en la collection del manager de Simpl)
        else
          console.log @tagAlongs.errors #REFACTOR!!!
