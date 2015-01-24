$(()->
  # Variables:

  comments = new Flixpot.Managers.Comments()
  veredicts = new Flixpot.Managers.Veredicts()
  veredict = parseInt($('#veredict_veredict').val())
  $('#nav').addClass('js-nav-dual')

  # Functions:

  delayedResize = () ->
    setTimeout () ->
      $('#comment_content').trigger('autosize.resize')
    , 160

  updateVeredict = () ->
    $('#veredict_veredict').val(veredict)
    veredicts.add '#veredicts-form', (success) ->
      if success
        updateVeredictLists()
      else
        #REFACTOR

  updateVeredictLists = () ->
    # We shouldn't have to be refetching the veredicts here. REFACTOR!!
    veredicts.fetch ->
      $('#veredict-lists').empty()
      $('#veredict-lists').append(veredicts.getPositiveUsersString($('#current_user_id').val()))
      $('#veredict-lists').append(veredicts.getNegativeUsersString($('#current_user_id').val()))
    , {spot_id: $('#spot_id').val()}

  # Jquery binds:

  $('#veredict-lists').click () ->
    veredicts.showCollection()
    $.magnificPopup.open
      items:
        src: '#veredict-collection-popup'
        type: 'inline'
      mainClass: 'mfp-zoom-in'
      removalDelay: 300

  $('#comment_content').autosize(
    append: false
    placeholder: true
  )

  $('#comment_content').on 'focus', () ->
    $('#action-bar').addClass('action-bar--text-expanded')
    delayedResize()

  $('#comment_content').on 'blur', () ->
    $('#action-bar').removeClass('action-bar--text-expanded')
    delayedResize()

  $('a[href="#"]').click (evt) ->
    evt.preventDefault()

  $('#spot-pubdate').html(moment($('#spot-pubdate').html(), 'YYYY-MM-DD HH:mm:ss Z').format('MMMM Do, YYYY - h:mm a'))

  $('#action-done').click (evt) ->
    $('#comments-form').submit()

  $('#action-thumb-up').click (evt) ->
    if veredict <= 0
      $(@).addClass('color-positive')
      if veredict == -1
        $('#action-thumb-down').removeClass('color-negative')
      veredict = 1
    else
      $(@).removeClass('color-positive')
      veredict = 0
    updateVeredict()

  $('#action-thumb-down').click (evt) ->
    if veredict >= 0
      $(@).addClass('color-negative')
      if veredict == 1
        $('#action-thumb-up').removeClass('color-positive')
      veredict = -1
    else
      $(@).removeClass('color-negative')
      veredict = 0
    updateVeredict()

  $('#comment_content').keyup (evt) ->
    if $('#comment_content').val() is ''
      $('#action-done').addClass('link-disabled')
    else
      $('#action-done').removeClass('link-disabled')

  $("#comments-form").on "submit", (evt) ->
    evt.preventDefault()
    ###$submit = $(@).find(":submit")
    $submit.prop("disabled", true)###
    comments.add "#comments-form", (success) ->
      comments.clearErrors()
      if success
        $('#comment_content').val('')
        delayedResize()
        #alert 'grabó!'
        #$("#js-spot-form").trigger('reset')
        #$("#spot_content").val('')
      else
        comments.showErrors()
      ###$submit.prop("disabled", false)###

  # Code:

  $.stellar(
    horizontalScrolling: false,
  )

  comments.fetch ->
    comments.showCollection()
  , {spot_id: $('#spot_id').val()}

  updateVeredictLists()
)
