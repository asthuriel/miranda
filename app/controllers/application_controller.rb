class ApplicationController < ActionController::Base
  layout 'application'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'themoviedb'
  require 'base'

  Tmdb::Api.key('300d2fb47e3f5f8d5e569ce27884acdc')
end
