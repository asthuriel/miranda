$(()->
  $.ajaxSetup(
    cache: false
  )
  spots = new Flixpot.Managers.Spots()
  spots.fixedOptions = {
    current_user_id: $('#user_id').val()
  }
  spots.veredictUpdateEnabled = true

  spots.fetch ->
    spots.showCollection()

  $(window).scroll ()->
    if $(window).scrollTop() + $(window).height() == $(document).height()
      spots.fetchMore ->
        spots.appendNew()
)

