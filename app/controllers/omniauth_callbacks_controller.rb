class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
   authenticate
  end

  def twitter
    authenticate
  end

  private

  def authenticate
    # render json: request.env['omniauth.auth']
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize) if is_navigational_format?
    else
      session[:provider] = @auth.provider
      session[:uid] = @auth.uid
      redirect_to confirm_email_for_auth_path
    end
  end
end
