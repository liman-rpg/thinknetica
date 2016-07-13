require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  before_action :set_gon_variables

  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_gon_variables
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

end
