# frozen_string_literal: true

# :Admin Panel Controller:
class AdminPanelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: false

  def index
    @users = User.where.not(id: current_user.id)
  end

  def users
    @users = User.where.not(id: current_user.id)
  end

  def change_access
    @user = User.find(params[:enable] || params[:disable])
    if params[:enable].present?
      @user.update(revoke_access: false)
    else
      @user.update(revoke_access: true)
    end
    redirect_to admin_panel_path
  end
end
