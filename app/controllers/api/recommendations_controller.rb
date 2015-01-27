class Api::RecommendationsController < ApplicationController
  def index
    limit = 20
    recommendations = Recommendation.includes([:recipient, :sender, {media_item: :parent}]).order(pubdate: :asc)

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

    resp = {
      meta: {
         resource_name: 'recommendations',
         count: recommendations.length
       },
       data: recommendations
    }

    # resp = {
    #   meta: {
    #     resource_name: 'recommendations',
    #     count: recommendations.length
    #   },
    #   data: recommendations.as_json({
    #     only: [:recipient_id, :sender_id, :media_item_id, :pubdate, :recipient, :sender, :media_item],
    #     include: [
    #       {recipient: {
    #         only: [:id, :username, :full_name, :avatar_url]
    #       }},
    #       {sender: {
    #         only: [:id, :username, :full_name, :avatar_url]
    #       }},
    #       {media_item: {
    #         only: [:id, :category, :parent_id, :title, :release_date, :tmdb_id, :backdrop_path, :poster_path, :season_number, :episode_number],
    #         include: [
    #           {parent: {
    #             only: [:id, :category, :parent_id, :title, :release_date, :tmdb_id, :backdrop_path, :poster_path, :season_number, :episode_number]
    #           }}
    #         ]
    #       }}
    #   ]})
    # }
    render json: resp
  end

  def create
    resp = {
      success: false,
      data: '',
      errors: []
    }
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
    render plain: resp.to_json
  end

  def destroy
  end

  private
    def recommendation_params
      params.require(:recommendation).permit(:recipient_id, :sender_id, :media_item_id, :spot_id)
    end
end
