class Flixpot.Managers.Notifications extends SimPL.Manager
  endpoint: '/api/notifications'
  collectionItemTemplate: 'notifications_collection'
  collectionContainer: '#notifications'

  controlData:
    objname: 'notification'

  collectionEvents:
    'click .js-user-link': 'goToUser'
    'click': 'clickItem'

  goToUser: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.sender.username

  clickItem: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    if (evt.data.item.status isnt 2)
      evt.data.item.set('status', 2)
      @update evt.data.item, (success) ->
        if not success
          console.log 'pava' #REFACTOR!!!###

    if evt.data.item.category is 0
      window.location.href = '/' + evt.data.item.sender.username
    else if evt.data.item.category is 1
      window.location.href = '/' + evt.data.item.recipient.username + '/spots/' + evt.data.item.reference_id + '#comments'
    else if _.contains([2, 3], evt.data.item.category)
      window.location.href = '/' + evt.data.item.recipient.username + '/spots/' + evt.data.item.reference_id + '#veredict-lists'

  afterShow: (item) =>
    if (item.status is 0)
      @unread = @unread-1
      if @unread > 0
        unreadEl = _sh.tagify(@unread, 'span', 'notification-blurb')
        @unreadContainer.html(unreadEl)
      else
        $('#notifications-icon').removeClass('icon-notifications-on')
        $('#notifications-icon').addClass('icon-notifications-none')
        @unreadContainer.fadeOut('fast')

      item.set('status', 1)
      @update item, (success) ->
        if not success
          console.log 'pava' #REFACTOR!!!###

  getMediaItemTitle: (item) -> #REFACTOR this done in 3 different places the same way
    if item.category is 0
      return item.title
    else if item.category is 2
      return item.parent.title + " " + item.season_number + "." + item.episode_number + ": " + item.title

  beforeShow: (item) ->
    desc = ''
    desc += _sh.tagify('', 'span', 'icon icon--inline-left icon-#{icon} color-#{color}')
    desc += _sh.tagify(item.sender.full_name, 'strong')
    color = 'default'
    if item.category is 0
      desc += ' is now tagging along with you'
      icon = 'person-add'
      color = 'positive'
    if item.category is 1
      desc += ' commented your checkup of '
      desc += _sh.tagify(@getMediaItemTitle(item.reference.media_item), 'strong')
      icon = 'comment-full'
    else if item.category is 2
      desc += ' agrees with your checkup of '
      desc += _sh.tagify(@getMediaItemTitle(item.reference.media_item), 'strong')
      icon = 'thumbs-up-black'
      color = 'positive'
    else if item.category is 3
      desc += ' booed your checkup of '
      desc += _sh.tagify(@getMediaItemTitle(item.reference.media_item), 'strong')
      icon = 'thumbs-down-black'
      color = 'negative'
    desc = desc.replace(/#{icon}/g, icon).replace(/#{color}/g, color)
    desc += '.'
    item.desc = desc


