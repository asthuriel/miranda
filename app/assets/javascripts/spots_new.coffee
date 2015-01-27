$(()->
  $('#nav-done').click (evt) ->
    $("#spot-form").submit()

  veredict = 0

  if $('.js-select2').length
    $('.js-select2').select2(
      placeholder: "Add some friends here!"
      minimumInputLength: 1
      formatInputTooShort: () ->
        return ''
    )
    $('.js-select2').removeClass('hidden')

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
  recommendations = new Flixpot.Managers.Recommendations()

  $("#spot-form").on "submit", (evt) ->
    evt.preventDefault()
    if veredict == 0
      swal("Hey!", "Remember to set your veredict (thumbs up or down)! Right now, they are mandatory. Let me know if you want this to change!", 'error')
    else
      $('#spot_veredict').val(veredict)

      spots.add "#spot-form", (success) ->
        spots.clearErrors()
        if success
          recipientArray = $('#people').val()
          if recipientArray
            recommendations.batchAdd spots.item.id, spots.item.media_item_id, $('#spot_user_id').val(), recipientArray, (success) ->
              if success
                console.log 'success'
                window.location.href = '/'
              else
                console.log recommendations.errors
          else
            window.location.href = '/'
          #alert 'grabó!'
          #$("#js-spot-form").trigger('reset')
          #$("#spot_content").val('')
        else
          console.log 'error', spots.errors
          #swal("We're sorry :(", "An unknown error didn't allow for your checkup to be created.
          #But don't despair! Our error fixing gnomes have been notified and are working
          #to solve the problem. Please try again later.", 'error')

  )
