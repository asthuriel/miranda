class SpotsController < ApplicationController
  def new
    if not (user_signed_in? and params[:tmdb_id] and params[:media_item_title] and params[:category])
      redirect_to root_path
    else
      @category = params[:category].to_i
      if not (@category == 0 or @category==2)
        redirect_to root_path
      else
        @tmdb_id = params[:tmdb_id]
        @media_item_title = params[:media_item_title]
        @tag_alongs = TagAlong.select('tag_alongs.*, users.id as tagged_id, users.full_name as tagged_full_name')
          .where(tagger_id: current_user.id).joins('join users on users.id = tag_alongs.tagged_id').order('tagged_full_name')

        if @category == 2
          if not (params[:series_id] and params[:season_number] and params[:episode_number])
            redirect_to root_path
          else
            @series_id = params[:series_id]
            @season_number = params[:season_number]
            @episode_number = params[:episode_number]
          end
        end
      end
    end
  end

  def show
    @spot = Spot.includes([:user, {media_item: :parent}]).find(params[:spot_id])
    if user_signed_in?
      @user_veredict = Veredict.where(user_id: current_user.id, spot_id: params[:spot_id]).first
    end
    @positive_veredicts = Veredict.where(spot_id: params[:spot_id], veredict: 1).includes(:user).order(:pubdate)
    @negative_veredicts = Veredict.where(spot_id: params[:spot_id], veredict: -1).includes(:user).order(:pubdate)
  end

  def index
    # @spots = Spot.includes([:media_item, :user]).where(params[:spot_id])
    if params[:username]
      @user = User.where('lower(users.username) = ?', params[:username].downcase)
      if user_signed_in?
        #.group('users.id')
        @user = @user.select('users.*, t.id as tag_id, t.tagger_id')
          .joins('left outer join tag_alongs as t on tagged_id = users.id and tagger_id = '+current_user.id.to_s)
      end
      @user = @user.first

      last_spot = Spot.where(user: @user).order(pubdate: :desc).includes(:media_item).first

      if last_spot
        @last_media = last_spot.media_item
      end

      unless @user
        #refactor raise 404 here
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
