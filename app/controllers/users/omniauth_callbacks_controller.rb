class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    session[:user_info] = request.env["omniauth.auth"].info
    session[:credentials] = request.env["omniauth.auth"].credentials
    image = session[:user_info]['image'].split('?')[0]
    session[:user_info]['image'] = image
    session[:user_info]['google_id'] = request.env["omniauth.auth"].uid
    session[:user_info]['provider'] = request.env["omniauth.auth"].provider

    @user = User.find_for_google_oauth2(request.env["omniauth.auth"])

    if @user
      session[:known_users] =  User.fetch_known_users(session[:credentials].token, @user.id)
      #flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      #flash[:notice] = "You have successfully logged in."
      sign_in_and_redirect @user, :event => :authentication
    else
      session[:known_users] =  User.fetch_known_users(session[:credentials].token)
      #flash[:notice] = "You haven't signed up to use the app yet."
      session[:user_new] = true
      redirect_to signup_path
    end

    # @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    # if @user.persisted?
    #   flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
    #   sign_in_and_redirect @user, :event => :authentication
    # else
    #   session["devise.google_data"] = request.env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end
  end
end
