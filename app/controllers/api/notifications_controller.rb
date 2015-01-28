class Api::NotificationsController < ApplicationController
  def index
    limit = 25

    if not user_signed_in?
      resp = Base.transaction_response('notifications')
      resp[:errors].push("You need to be logged in to use this API endopint")
    else
      notifications = Notification.where(recipient_id: current_user.id).includes(:recipient, :sender).order(pubdate: :desc).limit(limit)
      if params[:page]
        offset = params[:page].to_i
        offset = (offset-1)*limit
        notifications = notifications.offset(offset)
      end
      notif_array = []
      reference = nil
      notifications.each do |notif|
        if [1, 2, 3, 4].include? notif.category
          reference = Spot.where(id: notif.reference_id).includes([{media_item: :parent}]).first
          reference = reference.as_json(
            only: :media_item,
            include: {media_item: {include: :parent}}
          )
        end
        notif_array.push({
          id: notif.id,
          pubdate: notif.pubdate,
          category: notif.category,
          status: notif.status,
          reference: reference,
          reference_id: notif.reference_id,
          sender: notif.sender,
          recipient: notif.recipient
        })
      end
      resp = Base.list_response('notifications', notif_array.length, notif_array)
    end
    render json: resp
  end

  def update
    resp = Base.transaction_response('notifications')
    if not user_signed_in?
      resp[:errors].push("You need to be logged in to use this API endopint")
    else
      notification = Notification.where(id: params[:id]).first
      if not notification
        resp[:errors].push("Object is forbidden or doesn't exist.")
      else
        if notification.recipient.id != current_user.id
          resp[:errors].push("Object is forbidden or doesn't exist.")
        else
          if not notification.update(notification_params)
            resp[:errors] = notification.errors.full_messages
          else
            resp[:success] = true
            resp[:data] = notification
          end
        end
      end
    end
    render json: resp
  end

  private
    def notification_params
      params.require(:notification).permit(:status)
    end
end
