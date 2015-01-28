class Api::VeredictsController < ApplicationController
  def index
    if not params[:spot_id]
      resp = Base.transaction_response('veredicts')
      resp[:errors].push("The spot id is required to use this API endpoint")
    else
      veredicts = Veredict.where(spot_id: params[:spot_id]).includes(:user).order(pubdate: :desc) # REFACTOR: Do we need to limit here? .limit(20)
      data = veredicts.as_json(include: :user)
      resp = Base.list_response('veredicts', veredicts.length, data)
    end
    render json: resp
  end

  def create
    resp = Base.transaction_response('veredicts')
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
        end
      end
    else
      if veredict.save
        resp[:success] = true
        resp[:data] = veredict
      else
        resp[:errors] = veredict.errors.full_messages
      end
    end
    render json: resp
  end

  private
    def veredict_params
      params.require(:veredict).permit(:user_id, :spot_id, :veredict)
    end
end
