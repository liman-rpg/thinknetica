class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subscriptable, only: :create

  respond_to :js

  def create
    @subscription = @subscriptable.subscriptions.create!(user: current_user)
    respond_with(@subscription)
  end

  private

  def find_subscriptable
    @subscriptable = subscriptable_type.classify.constantize.find(params[:id])
  end

  def subscriptable_type
    params[:subscriptable].singularize
  end
end
