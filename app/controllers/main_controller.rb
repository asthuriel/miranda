class MainController < ApplicationController
  def index
    if not user_signed_in?
      render :layout => 'marketing'
    end
  end

  def movies
    if not user_signed_in?
      redirect_to root_path
    end
  end

  def tvshows
    if not user_signed_in?
      redirect_to root_path
    end
  end

  def notifications
    if not user_signed_in?
      redirect_to root_path
    end
  end
end
