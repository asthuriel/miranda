class Api::CommentsController < ApplicationController
  def index
    if not params[:spot_id]
      comments = Comment.all.includes(:user).includes(:spot).order(pubdate: :asc) #.limit(20) REFACTOR: Should limit comments here.
    else
      comments = Comment.where(spot_id: params[:spot_id]).includes(:user).includes(:spot).order(pubdate: :asc) #.limit(20)
    end
    resp = {
      meta: {
        resource_name: 'comments',
        count: comments.length
      },
      data: comments.as_json(include: [{user: {only: [:id, :username, :full_name, :bio, :avatar_url, :tagged_id]}},
                            {spot: {only: [:id]}}])
    }
    render plain: resp.to_json
  end

  def show
    comment = Comment.where(id: params[:id])[0]
    resp = {
      meta: {
        resource_name: 'comments'
      },
      data: comment.as_json(include: [{user: {only: [:id, :username, :full_name, :bio, :avatar_url, :tagged_id]}},
                            {spot: {only: [:id]}}])
    }
    render plain: resp.to_json
  end

  def create
    resp = {
      success: false,
      data: '',
      errors: []
    }
    comment = Comment.new(comment_params)
    if comment.save
      resp[:success] = true
      resp[:data] = comment
      render plain: resp.to_json(include: [:user, :spot])
    else
      resp[:errors] = comment.errors.full_messages
      render plain: resp.to_json
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :spot_id, :content)
    end
end
