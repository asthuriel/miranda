Handlebars.registerHelper 'relativeDate', (date)->
  return moment(date).fromNow()

Handlebars.registerHelper 'yearOfDate', (date)->
  return moment(date).year()

Handlebars.registerHelper 'formattedDate', (date)->
  return moment(date).format('MMM D, YYYY')

Handlebars.registerHelper 'replaceReturns', (text)->
  return text.replace(/(\r\n|\n|\r)/g,"</p><p>")

Handlebars.registerHelper 'formatCount', (count)->
  if count
    if count > 0
      return count
  return ''

Handlebars.registerHelper 'mediaItemTitle', (mediaItem)->
  #REFACTOR this done in 3 different places the same way
  if mediaItem.category == 0
    return mediaItem.title
  else if mediaItem.category == 2
    return mediaItem.parent.title + " " + mediaItem.season_number + "." + mediaItem.episode_number + ": " + mediaItem.title

Handlebars.registerHelper 'veredictToText', (val, type) ->
  if val > 0
    return if type is 'class' then 'positive' else 'up'
  else
    return if type is 'class' then 'negative' else 'down'

Handlebars.registerHelper 'tagIdToIcon', (val) ->
  if val
    return 'remove-circle'
  else
    return 'person-add'

Handlebars.registerHelper 'notificationBgnd', (val) ->
  if val is 0 or val is 1
    return 'list-item--alternate'
  else
    return ''

