class Flixpot.Managers.Spots extends SimPL.Manager
  endpoint: '/api/spots'
  collectionItemTemplate: 'spots_collection'
  collectionContainer: '#spots'

  collectionEvents:
    'click .js-thumb-up': 'thumbUp'
    'click .js-thumb-down': 'thumbDown'
    'click .js-user-link': 'goToUser'
    'click': 'clickItem'

  veredictsMgr: null

  veredictUpdateEnabled: false

  constructor: () ->
    @veredictsMgr = new Flixpot.Managers.Veredicts()

  updateVeredict: (item, compVal) ->
    if item.user_veredict
      if item.user_veredict is compVal
        if compVal is 1
          item.positive_veredicts_count--
        else
          item.negative_veredicts_count--
        item.set('user_veredict', null)
      else
        if compVal is 1
          item.positive_veredicts_count++
          item.negative_veredicts_count--
        else
          item.negative_veredicts_count++
          item.positive_veredicts_count--
        item.set('user_veredict', compVal)
    else
      if compVal is 1
        item.positive_veredicts_count++
      else
        item.negative_veredicts_count++
      item.set('user_veredict', compVal)

    $('#veredict_spot_id').val(item.id)
    if item.user_veredict
      $('#veredict_veredict').val(item.user_veredict)
    else
      $('#veredict_veredict').val(0)

    @veredictsMgr.add "#veredicts-form", (success) ->
      if not success
        console.log 'pava' #REFACTOR!!!

  thumbUp: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    if @veredictUpdateEnabled
      @updateVeredict(evt.data.item, 1)

  thumbDown: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    if @veredictUpdateEnabled
      @updateVeredict(evt.data.item, -1)

  goToUser: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.user.username

  clickItem: (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.user.username + '/spots/' + evt.data.item.id

  beforeRender: ($el, item) ->
    if item.user_veredict
      if item.user_veredict > 0
        $el.find('.js-thumb-up').addClass('btn-spot--positive')
      else
        $el.find('.js-thumb-down').addClass('btn-spot--negative')


