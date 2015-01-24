$(()->
  ###window.ParsleyValidator
  .addValidator('ikebana', (value, requirement) ->
    console.log value, requirement
    return true
  , 32)
  .addMessage('en', 'multiple', 'This value should be a multiple of %s')
  .addMessage('fr', 'multiple', 'Cette valeur doit être un multiple de %s');###

  $('#users-form').parsley()

  parsleydUsername = $('#user_username').parsley()
  parsleydUsername.addAsyncValidator('usernameAvailable', (xhr) ->
    resp = xhr.responseText
    if resp is 'false'
      return true
    return false
  , '/api/validation/username_exists')

)
