$(()->
  $('#nav-done').click (evt) ->
    $("#spot-form").submit()

  veredict = 0

  $('#btn-thumbs-up').click (evt) ->
    $(@).addClass('color-positive')
    if veredict is -1
      $('#btn-thumbs-down').removeClass('color-negative')
    veredict = 1

  $('#btn-thumbs-down').click (evt) ->
    $(@).addClass('color-negative')
    if veredict is 1
      $('#btn-thumbs-up').removeClass('color-positive')
    veredict = -1

  tmdb_id = $('#spot_tmdb_id').val()
  spots = new Flixpot.Managers.Spots()

  $("#spot-form").on "submit", (evt) ->
    evt.preventDefault()
    if veredict == 0
      swal("Hey!", "Remember to set your veredict (thumbs up or down)! Right now, they are mandatory. Let me know if you want this to change!", 'error')
    else
      $('#spot_veredict').val(veredict)

      spots.add "#spot-form", (success) ->
        spots.clearErrors()
        if success
          window.location.href = '/'
          #alert 'grabó!'
          #$("#js-spot-form").trigger('reset')
          #$("#spot_content").val('')
        else
          console.log spots.errors
          #swal("We're sorry :(", "An unknown error didn't allow for your checkup to be created. But don't despair! Our error fixing gnomes have been notified and are working to solve the problem. Please try again later.", 'error')

  )
