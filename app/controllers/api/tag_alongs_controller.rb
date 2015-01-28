class Api::TagAlongsController < ApplicationController
  def create
    resp = Base.transaction_response('tag_alongs')
    if not user_signed_in?
      resp[:errors].push("You need to be logged in to use this API endopint.")
    else
      if not (current_user.id == params[:tag_along][:tagger_id].to_i)
        resp[:errors].push("Forbidden.")
      else
        tag_along = TagAlong.where(tagger_id: params[:tag_along][:tagger_id], tagged_id: params[:tag_along][:tagged_id]).first
        if tag_along
          resp[:errors].push("Existing tag along.")
        else
          tag_along = TagAlong.new(tag_along_params)
          if tag_along.save
            resp[:success] = true
            resp[:data] = tag_along
          else
            resp[:errors] = tag_along.errors.full_messages
          end
        end
      end
    end
    render json: resp
  end

  def destroy
    resp = Base.transaction_response('tag_alongs')
    if not user_signed_in?
      resp[:errors].push("You need to be logged in to use this API endopint")
    else
      tag_along = TagAlong.where(id: params[:id]).first
      if tag_along
        if tag_along.tagger_id == current_user.id
          if tag_along.destroy
            resp[:success] = true
            resp[:data] = nil
            resp[:errors] = tag_along.errors.full_messages
          end
        else
          resp[:errors].push("The selected tag along is forbidden or doesn't exist.")
        end
      else
        resp[:errors].push("The selected tag along is forbidden or doesn't exist.")
      end
    end
    render json: resp
  end

  private
    def tag_along_params
      params.require(:tag_along).permit(:tagger_id, :tagged_id)
    end
end
