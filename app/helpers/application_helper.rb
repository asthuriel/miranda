module ApplicationHelper
  def new_notif_count
    if user_signed_in?
      return Notification.new_count(current_user)
    else
      return 0
    end
  end
end
