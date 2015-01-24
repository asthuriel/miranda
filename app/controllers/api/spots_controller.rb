class Api::SpotsController < ApplicationController
  def index
    #spots = Spot.all.includes(:user).includes(:media_item).order(pubdate: :desc).limit(20)
    limit = 25

    spots = Spot.includes([:user, {media_item: :parent}]).group('spots.id').order(pubdate: :desc).limit(limit)
      .joins('left outer join (select c2.spot_id as spot_id, count(c2.id) as count from comments as c2 group by c2.spot_id) as c on c.spot_id = spots.id')
      .joins('left outer join (select pv2.spot_id as spot_id, count(pv2.id) as count from veredicts as pv2 where pv2.veredict = 1 group by pv2.spot_id) as pv on pv.spot_id = spots.id')
      .joins('left outer join (select nv2.spot_id as spot_id, count(nv2.id) as count from veredicts as nv2 where nv2.veredict = -1 group by nv2.spot_id) as nv on nv.spot_id = spots.id')

    if params[:current_user_id]
      spots = spots.select('spots.*, c.count as comments_count, pv.count as positive_veredicts_count, nv.count as negative_veredicts_count, uv.user_veredict as user_veredict')
        .joins('left outer join (select uv2.spot_id as spot_id, uv2.veredict as user_veredict from veredicts as uv2 where uv2.user_id = ' + params[:current_user_id] + ' group by uv2.spot_id) as uv on uv.spot_id = spots.id')
    else
      spots = spots.select('spots.*, c.count as comments_count, pv.count as positive_veredicts_count, nv.count as negative_veredicts_count, null as user_veredict')
    end

    if params[:user_id]
      spots = spots.where(user_id: params[:user_id])
    else
      if params[:current_user_id]
         spots = spots.where('spots.user_id = ' + params[:current_user_id] + ' or spots.user_id in (select t.tagged_id from tag_alongs as t where tagger_id = ' + params[:current_user_id] + ')')
      end
    end

    if params[:page]
      offset = params[:page].to_i
      offset = (offset-1)*limit
      spots = spots.offset(offset)
    end

    resp = {
      meta: {
        resource_name: 'spots',
        count: spots.length
      },
      data: spots.as_json(include: [
        {user:
          {only: [:email, :id, :username, :full_name, :bio, :avatar_url, :tagged_id]}
        },
        {media_item:
          {only: [:id, :title, :release_date, :category, :season_number, :episode_number],
           include: [
             {parent:
               {only: [:id, :title, :release_date]}
             }
           ]
         }
        }
      ])
    }
    render plain: resp.to_json()
  end

  def show
    spot = Spot.where(id: params[:id])[0]
    resp = {
      meta: {
        resource_name: 'spots'
      },
      data: spot
    }
    render plain: resp.to_json
  end

  def create
    resp = {
      success: false,
      data: '',
      errors: []
    }
    if params[:spot][:tmdb_id] and params[:category]
      tmdb_id = params[:spot][:tmdb_id]
      media_item = MediaItem.where(tmdb_id: tmdb_id, category: params[:category]).first
      if not media_item
        category = params[:category].to_i
        if category == 0
          media_item = create_movie_item(tmdb_id, resp[:errors])
        elsif category == 2
          if params[:series_id] and params[:season_number] and params[:episode_number]
            media_item = create_episode_item(params[:series_id], params[:season_number], params[:episode_number], resp[:errors])
          else
            resp[:errors].push("Params missing")
          end
        else
          resp[:errors].push("Chosen category unsupported")
        end
      end
      if media_item
        spot = Spot.new(spot_params)
        spot.media_item = media_item
        if spot.save
          resp[:success] = true
          resp[:data] = spot
        else
          resp[:errors] = spot.errors.full_messages
        end
      end
    else
      resp[:errors].push("Params missing")
    end
    render plain: resp.to_json
  end

  private
    def create_show_item(show_id, errors)
      show_item = nil
      show = Tmdb::TV.detail(show_id)
      if show.name
        media_item = MediaItem.new(
          title: show.name,
          release_date: show.first_air_date,
          tagline: '',
          overview: show.overview || '',
          cast: get_creators(show.created_by),
          category: 1,
          tmdb_id: show.id,
          backdrop_path: show.backdrop_path || '',
          poster_path: show.poster_path || ''
        )
        if media_item.validate
          media_item.save
          show_item = media_item
        else
          errors = media_item.errors.full_messages
          errors.push("There was an error saving the new media item for this spot. The spot can't be created.")
        end
      else
        errors.push("No show with the id "+show_id+" could be found. The spot can't be created.")
      end
      return show_item
    end

    def create_episode_item(show_id, season_number, episode_number, errors)
      episode_item = nil
      show = MediaItem.where(tmdb_id: show_id, category: 1).first
      if not show
        show = create_show_item(show_id, errors)
      end
      if show
        episode = Tmdb::Episode.detail(show_id, season_number, episode_number)
        if episode.name
          media_item = MediaItem.new(
            title: episode.name,
            release_date: episode.air_date,
            tagline: '',
            overview: episode.overview || '',
            category: 2,
            tmdb_id: episode.id,
            backdrop_path: episode.still_path || '',
            poster_path: '',
            parent: show,
            season_number: season_number,
            episode_number: episode_number
          )
          if media_item.validate
            media_item.save
            episode_item = media_item
          else
            errors = media_item.errors.full_messages
            errors.push("There was an error saving the new media item for this spot. The spot can't be created.")
          end
        else
          errors.push("No episode with the selected id could be found. The spot can't be created.")
        end
      end
      return episode_item
    end

    def create_movie_item(tmdb_id, errors)
      movie_item = nil
      movie = Tmdb::Movie.detail(tmdb_id)
      if movie.title
        media_item = MediaItem.new(
          title: movie.title,
          release_date: movie.release_date,
          tagline: movie.tagline || '',
          overview: movie.overview || '',
          cast: get_cast(movie.id),
          category: 0,
          tmdb_id: movie.id,
          backdrop_path: movie.backdrop_path || '',
          poster_path: movie.poster_path || ''
        )
        if media_item.validate
          media_item.save
          movie_item =  media_item
        else
          errors = media_item.errors.full_messages
          errors.push("There was an error saving the new media item for this spot. The spot can't be created.")
        end
      else
        errors.push("No movie with the selected id could be found. The spot can't be created.")
      end
      return movie_item
    end

    def get_creators(array)
      creators = ''
      array.each do |creator|
        creators += creator.name + ', '
      end
      creators = creators[0..-3] + '.'
      return creators
    end

    def get_cast(id)
      movie = Tmdb::Movie.casts(id)
      cast = ''
      movie.first(4).each do |member|
        cast += member.name + ', '
      end
      cast = cast[0..-3] + '.'
      return cast
    end

    def spot_params
      params.require(:spot).permit(:user_id, :review, :veredict)
    end
end
