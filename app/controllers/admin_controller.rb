class AdminController < ApplicationController
  before_action :require_admin!

  def index

  end

  def require_admin!
    authenticate_user!
    unless current_user.admin
      flash[:alert] = "You are not an admin"
      redirect_to '/'
    end
  end

end
