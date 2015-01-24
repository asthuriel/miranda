$(()->
  users = new Flixpot.Managers.Users()
  user_id = $('#user_id').val()

  users.fetch ->
    users.showCollection()
  , {tagged_by: user_id, show_if_tagged_by: user_id}
)
