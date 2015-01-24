class Api::VeredictsController < ApplicationController
  def index
    if not params[:spot_id]
      resp = {
        success: false,
        errors: ['The spot id is required to use this API endpoint']
      }
    else
      veredicts = Veredict.where(spot_id: params[:spot_id]).includes(:user).order(pubdate: :desc) # REFACTOR: Do we need to limit here? .limit(20)
      resp = {
        meta: {
          resource_name: 'veredicts',
          count: veredicts.length
        },
        data: veredicts.as_json(include: {user: {only: [:id, :username, :full_name, :bio, :avatar_url, :tagged_id]}})
      }
    end
    render plain: resp.to_json()
  end

  def create
    resp = {
      success: false,
      data: '',
      errors: []
    }

    veredict = Veredict.where(user_id: params[:veredict][:user_id], spot_id: params[:veredict][:spot_id]).first

    if veredict
      veredict.veredict = params[:veredict][:veredict]
      veredict.pubdate = DateTime.now
    else
      if params[:veredict][:veredict] != "0"
        veredict = Veredict.new(veredict_params)
      end
    end

    if params[:veredict][:veredict] == "0"
      if veredict
        if veredict.destroy
          resp[:success] = true
          resp[:data] = nil
          render plain: resp.to_json
        end
      end
    else
      if veredict.save
        resp[:success] = true
        resp[:data] = veredict
        render plain: resp.to_json
      else
        resp[:errors] = veredict.errors.full_messages
        render plain: resp.to_json
      end
    end
  end

  private
    def veredict_params
      params.require(:veredict).permit(:user_id, :spot_id, :veredict)
    end
end
