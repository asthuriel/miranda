class Api::CommentsController < ApplicationController
  def index
    if not params[:spot_id]
      comments = Comment.all.includes(:user).order(pubdate: :asc) #.limit(20) REFACTOR: Should limit comments here.
    else
      comments = Comment.where(spot_id: params[:spot_id]).includes(:user).order(pubdate: :asc) #.limit(20)
    end
    resp = Base.list_response('comments', comments.length, comments.as_json(include: :user))
    render json: resp
  end

  def create
    resp = Base.transaction_response('comments')
    comment = Comment.new(comment_params)
    if comment.save
      resp[:success] = true
      resp[:data] = comment.as_json(include: :user)
    else
      resp[:errors] = comment.errors.full_messages
    end
    render json: resp
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :spot_id, :content)
    end
end
