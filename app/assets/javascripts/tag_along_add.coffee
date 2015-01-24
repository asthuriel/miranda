$(()->
  users = new Flixpot.Managers.Users()
  known_users_ids = $('#known_users_ids').val().split(',')
  user_id = $('#user_id').val()

  refreshResults = (searchString) ->
    if searchString.length >= 3
      $('#search-input__loading').show()
      users.fetch ->
        $('#search-input__loading').hide()
        users.showCollection()
      , {search_string: searchString, exclude_user: user_id, show_if_tagged_by: user_id}

    else if searchString == ''
      $('#search-input__loading').show()
      users.fetch ->
        $('#search-input__loading').hide()
        users.showCollection()
      , {in_list: known_users_ids, not_tagged_by: user_id}

  searchInput = new Flixpot.Modules.SearchInput({
    placeholder: "Search..."
    refreshResults: refreshResults
  })

  refreshResults('')
)
