@SimPL = {}

Array.prototype.blank = () ->
  (@length == 0)

String.prototype.includes = (regexp) ->
  regexp.test(@toLowerCase())

SimPL.Config =
  applyTemplate: (template, object) ->
    return HandlebarsTemplates[template](object)

SimPL.Helpers =
  tagify: (text, htmlTag, tagClass) ->
    myClass = if tagClass then ' class="' + tagClass + '"' else ''
    return '<'+htmlTag+ myClass + '>' + text + '</'+htmlTag+'>'

@_sh = SimPL.Helpers

class SimPL.Item
  constructor: (parent) ->
    @['__control__'] = {}
    @['__simpl__'] = {}
    @['__simpl__'].children = {}
    @['__simpl__'].parent = parent
    @['__simpl__'].modified = false
    if parent.controlData
      attrList = _.keys(parent.controlData)
      for attr in attrList
        @['__control__'][attr] = parent.controlData[attr]

  getEndpoint: () ->
    return @['__simpl__'].parent.getEndpoint() + '/' + @id

  refresh: () ->
    $el = $(SimPL.Config.applyTemplate(@['__simpl__'].template, @))
    @['__simpl__'].parent.beforeRender($el, @)
    @['__simpl__'].$el.replaceWith($el)
    @['__simpl__'].$el = $el
    @['__simpl__'].parent.addEventsToEl($el, @)
    @['__simpl__'].parent.afterRender($el)

  addChild: (name, manager) ->
    @[name] = manager
    manager.parent = @

  set: (attr, val) ->
    if @[attr] isnt val
      @[attr] = val
      @['__simpl__'].modified = true
      if @['__simpl__'].showing
        @refresh()


class SimPL.Manager
  endpoint: ''
  itemTemplate: ''
  itemContainer: ''
  collectionItemTemplate: ''
  collectionFetchTemplate: ''
  $collectionFetchEl: null
  collectionEmptyTemplate: ''
  collectionContainer: ''
  fetchingCollection: false
  errorsTemplate: ''
  errorContainer: ''
  collection: []
  item: null
  errors: []
  tempTemplate: null
  tempContainer: null
  tempEndpoint: null
  onAdd: 'prepend'
  addingItem: false
  showingEmpty: false
  showingCollection: false
  jsonContainerName: 'data'
  jsonCollectionContainer: 'data'
  jsonItemContainer: 'data'
  fixedOptions: {}
  endpointExtra: ''
  currentPage: 0
  paginated: true
  pageParamName: 'page'
  showingAll: false
  collectionNew: []

  collectionEvents: null

  constructor: () ->
    true

  addError: (text) ->
    @errors.push text

  afterFetch: (collection) ->
    true

  get: (id, callback) ->
    @item = null
    endpoint = @endpoint + '/' + id #REFACTOR

    if @endpointExtra isnt ''
      endpoint += '/' + @endpointExtra #REFACTOR

    paramString = '?'
    fixedParamList = _.keys(@fixedOptions)

    if not fixedParamList.blank()
      for param in fixedParamList
        paramString += param + '=' + @fixedOptions[param] + '&'

    if paramString isnt '?'
      endpoint += paramString.substring(0, paramString.length - 1)

    $.getJSON endpoint, (data) =>
      @item = data
      callback(@item)

  getEndpoint: () ->
    if @parent
      return @parent.getEndpoint() + @endpoint
    else
      return @endpoint


  find: (id, callback, extra) ->
    @item = null
    endpoint = @getEndpoint() + '/' + id #REFACTOR

    if extra?
      endpoint += '/' + extra #REFACTOR

    paramString = '?'
    fixedParamList = _.keys(@fixedOptions)

    if not fixedParamList.blank()
      for param in fixedParamList
        paramString += param + '=' + @fixedOptions[param] + '&'

    if paramString isnt '?'
      endpoint += paramString.substring(0, paramString.length - 1)

    $.getJSON endpoint, (data) =>
      @item = if @jsonItemContainer is '' then @simplify(data) else @simplify(data[@jsonItemContainer])
      callback(@item)

  simplify: (obj) ->
    item = new SimPL.Item(@)
    paramList = _.keys(obj)
    for key in paramList
      item[key] = obj[key]
    item

  mapCollection: (source) ->
    collection = []
    for item in source
      collection.push(@simplify(item))
    return collection

  setCollection: (collection, callback) ->
    @collection = []
    @showingAll = false
    @currentPage = 0

    @collectionNew = @mapCollection(collection)
    @collection = @collection.concat(@collectionNew)
    if callback
      callback()

  fetchElements: (callback, options, extra) ->
    if not @fetchingCollection
      @fetchingCollection = true

      if @collectionFetchTemplate
        if not @$collectionFetchEl
          @$collectionFetchEl = $(SimPL.Config.applyTemplate(@collectionFetchTemplate, {}))
        container = @tempContainer || @collectionContainer
        if container
          $(container).append(@$collectionFetchEl)

      if (@tempEndpoint)
        endpoint = @tempEndpoint
        @tempEndpoint = null
      else
        endpoint = @endpoint

      if extra?
        endpoint += '/' + extra #REFACTOR

      paramString = '?'
      fixedParamList = _.keys(@fixedOptions)

      if @paginated
        @currentPage++;
        paramString += @pageParamName + '=' + @currentPage + '&'

      if not fixedParamList.blank()
        for param in fixedParamList
          paramString += param + '=' + @fixedOptions[param] + '&'

      if options?
        paramList = _.keys(options) #Object.keys(options)
        if not paramList.blank()
          for param in paramList
            if options[param].constructor isnt Array
              paramString += param + '=' + options[param] + '&'
            else
              for item in options[param]
                paramString += param + '[]=' + item + '&'
            #paramString += (if paramString is '?' then '' else '&') + param + '=' + options[param]

      if paramString isnt '?'
        endpoint += paramString.substring(0, paramString.length - 1)

      $.getJSON endpoint, (data) =>
        @collectionNew = if @jsonCollectionContainer is '' then @mapCollection(data) else @mapCollection(data[@jsonCollectionContainer])
        if @collectionFetchTemplate
          @$collectionFetchEl.detach()
        @fetchingCollection = false
        if @paginated and @currentPage > 1 and @collectionNew.blank()
          @showingAll = true
        else
          @collection = @collection.concat(@collectionNew)
          @afterFetch(@collection)
          callback()

  fetch: (callback, options, extra) ->
    @collection = []
    @showingAll = false
    @currentPage = 0

    @fetchElements(callback, options, extra)

  fetchMore: (callback, options, extra) ->
    if @paginated and not @showingAll
      @fetchElements(callback, options, extra)

  validate: (item) ->
    if @errors.blank()
      true
    else
      false

  beforeSave: (item) ->
    true

  serialize: (item) ->
    string = ''
    objname = item.__control__.objname
    paramList = Object.keys(item)
    if not paramList.blank()
      for param in paramList
        if param is '__control__'
          controls = item[param]
          controlList = Object.keys(controls)
          for control in controlList
            if control != 'objname'
              string += control + '=' + encodeURIComponent(controls[control]) + '&'
        else
          if param isnt '__simpl__'
            string += objname + '%5B' + param + '%5D=' + encodeURIComponent(item[param]) + '&'
    string = string.substring(0, string.length - 1)
    return string

  destroy: (id, callback) ->
    # Needs a less serious REFACTOR!!!!!
    endpoint = @getEndpoint() + '/' + id
    success = false
    $.ajax
      type: 'DELETE'
      url: endpoint
      dataType: 'json'
      success: (data) ->
        success = data.success
        callback(success)

  update: (item, callback) ->
    # Needs a less serious REFACTOR!!!!!
    if item['__simpl__'].modified
      endpoint = @getEndpoint() + '/' + item.id
      success = false
      $.ajax
        type: 'PATCH'
        url: endpoint
        data: @serialize(item)
        dataType: 'json'
        success: (data) ->
          success = data.success
          callback(success)

  addElement: (item, callback) ->
    if not @addingItem
      @addingItem = true
      success = false
      @errors = []
      @beforeSave(item)
      if @validate(item)
        $.post @endpoint, @serialize(item), (data) =>
          if data.success
            success = true
            @item = if @jsonItemContainer is '' then @simplify(data) else @simplify(data[@jsonItemContainer])
            @collection.push(@item)
            if @showingCollection and @onAdd
              template = @tempTemplate || @collectionItemTemplate
              container = @tempContainer || @collectionContainer
              @addCollectionItem(@item, template, container, @onAdd)
            @tempTemplate = null
            @tempContainer = null
          else
            APIerrors = data.errors
            for error in APIerrors
              @errors.push error
          @addingItem = false
          callback(success)
        , 'json'
      else
        @addingItem = false
        callback(success)

  addItem: (item, callback) ->
    item = @simplify(item)
    @addElement(item, callback)

  add: (formId, callback) ->
    item = @createFrom(formId)
    @addElement(item, callback)

  withEndpoint: (endpoint) ->
    @tempEndpoint = endpoint
    return @

  withTemplate: (template) ->
    @tempTemplate = template
    return @

  inContainer: (containerId) ->
    @tempContainer = containerId
    return @

  beforeShow: (item) ->
    return true

  afterShow: (item) ->
    return true

  beforeRender: ($el, item) ->
    return true

  afterRender: ($el, item) ->
    return true

  addEventsToEl: ($el, item) ->
    if @collectionEvents
      keys = _.keys(@collectionEvents)
      for key in keys
        evtElem = key.split(' ')
        if evtElem.length > 1
          evt = evtElem[0]
          elem = evtElem[1]
          $el.find(elem).on(evt, {item: item}, @[@collectionEvents[key]])
        else
          evt = evtElem[0]
          $el.on(evt, {item: item}, @[@collectionEvents[key]])

  renderIf: (item) ->
    return true

  addCollectionItem: (item, template, container, type) ->
    if @renderIf(item)
      if @showingEmpty
        @showingEmpty = false
        $(container).empty()

      @beforeShow(item)

      $el = $(SimPL.Config.applyTemplate(template, item))
      @beforeRender($el, item)

      if type is 'append'
        $(container).append($el)
      else
        $(container).prepend($el)
      item['__simpl__'].showing = true
      item['__simpl__'].$el = $el
      item['__simpl__'].template = template

      @afterShow(item)
      @addEventsToEl($el, item)
      @afterRender($el, item)

  showItem: ->
    if $(@itemContainer)
      $(@itemContainer).empty()
      item = @item
      container = @itemContainer
      if item
        template = @itemTemplate
        $el = $(SimPL.Config.applyTemplate(template, item))
        $(container).append($el)

  afterCollectionShow: () ->
    return true

  showCollectionElements: (collectionParam, filter) ->
    collection = if filter then _.where(collectionParam, filter) else collectionParam
    container = @tempContainer || @collectionContainer
    if collection.blank()
      if @collectionEmptyTemplate
        $el = $(SimPL.Config.applyTemplate(@collectionEmptyTemplate, {}))
        $(container).append($el)
        @showingEmpty = true
    else
      template = @tempTemplate || @collectionItemTemplate
      for item in collection
        @addCollectionItem(item, template, container, 'append')
    @showingCollection = true
    @afterCollectionShow()
    @tempTemplate = null
    @tempContainer = null

  showCollection: (filter) ->
    if $(@collectionContainer)
      $(@collectionContainer).empty()
      @showCollectionElements(@collection, filter)

  appendNew: (filter) ->
    if $(@collectionContainer)
      @showCollectionElements(@collectionNew, filter)

  clearErrors: () ->
    if $(@errorContainer)
      $(@errorContainer).empty()

  showErrors: () ->
    if $(@errorContainer)
      @showErrorsIn(@errorContainer)

  showErrorsIn: (containerId) ->
    if @errorsTemplate
      elem = SimPL.Config.applyTemplate(@errorsTemplate, @errors)
    else
      ul = $('<ul/>').addClass('simpl-error-list')
      $.each @errors, (inx, item) ->
        li = $('<li/>').text(item).appendTo(ul)
      elem = ul
    $(containerId).html(elem)

  lastError: () ->
    @errors[@errors.length-1]

  createFrom: (formId) ->
    objname = ''
    obj = {}
    obj['__control__'] = {}
    array = $(formId).serializeArray()
    $.each array, (inx, item) ->
      itemname = item.name
      curobj = obj
      if itemname.indexOf("[") != -1
        parent = itemname.split("[")[0]
        if objname is ''
          objname = parent
          obj['__control__'].objname = objname
        child = itemname.split("[")[1].replace("]", "")
        itemname = child
      else
        curobj = obj['__control__']
      if curobj[itemname]?
        if not curobj[itemname].push
          curobj[itemname] = [curobj[itemname]]
        curobj[itemname].push(item.value || '')
      else
        curobj[itemname] = item.value || ''
    return obj




