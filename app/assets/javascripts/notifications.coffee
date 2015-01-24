$(()->
  notifications = new Flixpot.Managers.Notifications()
  notifications.unread = parseInt($('#notifications_unread').val())
  notifications.unreadContainer = $('#unread-notifications')

  notifications.fetch ->
    notifications.showCollection()

  $(window).scroll ()->
    if $(window).scrollTop() + $(window).height() == $(document).height()
      notifications.fetchMore ->
        notifications.appendNew()
)