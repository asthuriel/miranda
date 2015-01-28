class ExternalUsersController < ApplicationController
  def new
    if not session[:user_new] or user_signed_in?
      redirect_to root_path
    else
      @user_info = session[:user_info]
      username = @user_info["email"].split('@')[0]
      @username = username.gsub(/[^a-zA-Z0-9_]+/, '_')

      user = User.where('lower(username) = ?', @username).first
      while user
        @username = username + (1+rand(10000)).to_s
        user = User.where('lower(username) = ?', @username).first
      end
    end
  end

  def create
    user = User.new(user_params)
    user.password = Devise.friendly_token[0,20]
    if user.email == 'albertodlh@gmail.com'
      user.role = 'admin'
    end
    if user.save
      #flash[:notice] = "You have successfully logged in."
      #sign_in_and_redirect user, :event => :authentication, '/movies'
      sign_in user, :event => :authentication
      redirect_to tag_along_add_path
    else
      render plain: user.errors.full_messages
    end
  end

  private
    def user_params
      params.require(:user).permit(:full_name, :avatar_url, :username, :user_bio, :email, :google_id, :provider)
    end
end
