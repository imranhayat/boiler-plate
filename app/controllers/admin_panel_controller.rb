class AdminPanelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: false
  
  def index
  end

  def users
    @users = User.where.not(id: current_user.id)
  end
end
