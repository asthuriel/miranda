class Api::RecommendationsController < ApplicationController
  def index
    limit = 20
    recommendations = Recommendation.includes([:recipient, :sender, {media_item: :parent}]).order(pubdate: :asc).limit(limit)

    if params[:recipient_id]
      recommendations = recommendations.where(recipient_id: params[:recipient_id])
    end
    if params[:sender_id]
      recommendations = recommendations.where(sender_id: params[:sender_id])
    end
    if params[:media_item_id]
      recommendations = recommendations.where(media_item_id: params[:media_item_id])
    end

    if params[:page]
      offset = params[:page].to_i
      offset = (offset-1)*limit
      recommendations = recommendations.offset(offset)
    end

    data = recommendations.as_json(include: [:recipient, :sender, {media_item: {include: :parent}}, :spot])
    resp = Base.list_response('recommendations', recommendations.length, data)
    render json: resp
  end

  def create
    resp = Base.transaction_response('recommendations')
    if not user_signed_in?
      resp[:errors].push("You need to be logged in to use this API endopint.")
    else
      if not (current_user.id == params[:recommendation][:sender_id].to_i)
        resp[:errors].push("Forbidden.")
      else
        recommendation = Recommendation.new(recommendation_params)
        if recommendation.save
          resp[:success] = true
          resp[:data] = recommendation
        else
          resp[:errors] = recommendation.errors.full_messages
        end
      end
    end
    render json: resp
  end

  private
    def recommendation_params
      params.require(:recommendation).permit(:recipient_id, :sender_id, :media_item_id, :spot_id)
    end
end
