class Api::ValidationController < ApplicationController
  def username_exists
    reserved_words = ['api', 'signup', 'download', 'login', 'logout', 'admin', 'notifications', 'movies', 'tvshows', 'main', 'tag_along', 'tagalong', 'spot', 'spots', 'checkup', 'marketing', 'about', 'index']
    desired_username = params[:user][:username].downcase

    user = User.where('lower(username) = ?', desired_username).first
    if user or reserved_words.include? desired_username
      render plain: true
    else
      render plain: false
    end
  end
end
