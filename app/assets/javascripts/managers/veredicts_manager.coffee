class Flixpot.Managers.Veredicts extends SimPL.Manager
  endpoint: '/api/veredicts'
  collectionContainer: '#veredict-collection-container'
  collectionItemTemplate: 'veredicts_collection'
  onAdd: null

  collectionEvents:
    'click .js-user-link': 'goToUser'

  goToUser: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    window.location.href = '/' + evt.data.item.user.username

  afterFetch: (collection) ->
    #console.log collection

  isInSubset: (user_id, subset) ->
    inx = 0
    sw = false
    while (inx < subset.length) and (not sw)
      if subset[inx].user.id is user_id
        sw = true
      inx++
    return sw

  getUsersString: (veredict_val, message, message_sing, max, user_id) ->
    subset = _.where(@collection, {veredict: veredict_val})
    isHere = false
    displaying = 0

    $ret = ''
    ret = ''

    if subset.length > 0
      if user_id
        curId = parseInt(user_id)
        isHere = @isInSubset(curId, subset)
      if isHere
        ret += '<strong>You</strong>' + '<' + displaying + '>'
        displaying++
      inx = 0
      while (inx < subset.length) and (displaying < max)
        veredict = subset[inx]
        if (not isHere) or (isHere and veredict.user.id isnt curId)
          ret += '<strong>' + veredict.user.full_name + '</strong>' + '<' + displaying + '>'
          displaying++
        inx++
      if max < subset.length
        ret += '<strong>' + (subset.length - max) + ' more</strong><'+ displaying + '>'
      if displaying is 1 and not isHere
        ret += message_sing
      else
        ret += message
      if displaying is 1
        ret = ret.replace('<0>', ' ')
      else
        if subset.length > displaying
          ret = ret.replace('<' + max + '>', ' ')
          ret = ret.replace('<' + (displaying - 1) + '>', ' and ')
        else
          ret = ret.replace('<' + (displaying - 1) + '>', ' ')
          ret = ret.replace('<' + (displaying - 2) + '>', ' and ')
        ret = ret.replace(/<(\d)+>/g, ', ')

      $ret = $('<p/>').html(ret)
      $ret.addClass('spot__veredicts')
      if veredict_val is 1
        $icon = $('<span/>').addClass('icon icon-thumbs-up-black')
      else
        $icon = $('<span/>').addClass('icon icon-thumbs-down-black')
      $ret.prepend($icon)
    return $ret

  getPositiveUsersString: (user_id) ->
    return @getUsersString(1, 'agree with this.', 'agrees with this.', 5, user_id)

  getNegativeUsersString: (user_id) ->
    return @getUsersString(-1, 'booed this.', 'booed this.', 5, user_id)







