class TagAlongController < ApplicationController
  def index
    if not user_signed_in? # or not session[:user_new]
      redirect_to root_path
    end
  end

  def add
    if not user_signed_in? # or not session[:user_new]
      redirect_to root_path
    else
      @known_users = session[:known_users]
      #@known_users = User.fetch_known_users(session[:credentials].token, current_user.id)   #session[:user_info]['known_users']
      #@known_users = User.where()
    end
  end
end