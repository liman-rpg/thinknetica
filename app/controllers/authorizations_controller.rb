class AuthorizationsController < ApplicationController
  def confirm_email
  end

  def save_email
    email = params[:email]

    if email.blank?
      redirect_to confirm_email_for_auth_path
    else
      provider = session[:provider]
      uid = session[:uid]
      @user = User.where(email: email).first
      if @user
        @user.authorizations.create(provider: provider, uid: uid)
      else
        password = Devise.friendly_token[0, 20]
        @user = User.create!(email: email, password: password, password_confirmation: password)
        @user.authorizations.create(provider: provider, uid: uid)
      end
      redirect_to new_user_session_path
    end
  end

  # Не работают методы
  # undefined local variable or method `provider' for #<AuthorizationsController:0x00000008a95508>


  # def authoriz
  #   @user.authorizations.create(provider: provider, uid: uid)
  # end

  # def authorizations_with_create_email
  #   password = Devise.friendly_token[0, 20]
  #   @user = User.create!(email: email, password: password, password_confirmation: password)
  #   authoriz
  # end
end
