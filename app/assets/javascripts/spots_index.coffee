$(()->
  $('#nav').addClass('js-nav-dual')
  $.stellar(
    horizontalScrolling: false,
  )

  tagAlongs = new Flixpot.Managers.TagAlongs()
  spots = new Flixpot.Managers.Spots()
  spots.fixedOptions = {
    user_id: $('#user_id').val()
  }

  if $('#current_user_id').length
    spots.veredictUpdateEnabled = true
    spots.fixedOptions.current_user_id = $('#current_user_id').val()

  if $('#tag_id').val() != ''
    $('#untag-along-btn').show().css('display', 'inline-block')
  else
    $('#tag-along-btn').show().css('display', 'inline-block')

  tagAlong = (callback) ->
    tagAlongs.add $('#tag-alongs-form'), (success) ->
      if success
        $('#tag_id').val(tagAlongs.item.id)
        callback()
      else
        console.log tagAlongs.errors #REFACTOR!!!

  untagAlong = (callback) ->
    tagAlongs.destroy $('#tag_id').val(), (success) ->
      if success
        callback()
      else
        console.log tagAlongs.errors #REFACTOR!!!

  $('#tag-along-btn').click () ->
    tagAlong () ->
      $('#tag-along-btn').hide()
      $('#untag-along-btn').show().css('display', 'inline-block')

  $('#untag-along-btn').click () ->
    swal
      title: "Are you sure?"
      text: "You will no longer see this person's activity on your activity feed."
      type: "warning"
      showCancelButton: true
      confirmButtonColor: "#DD6B55"
      confirmButtonText: "I'm sure!"
      closeOnConfirm: true
    , () ->
      untagAlong () ->
        $('#untag-along-btn').hide()
        $('#tag-along-btn').show().css('display', 'inline-block')

  spots.fetch ->
    spots.showCollection()

  $(window).scroll ()->
    if $(window).scrollTop() + $(window).height() == $(document).height()
      spots.fetchMore ->
        spots.appendNew()
)
