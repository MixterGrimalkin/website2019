class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :require_admin!

  def index
    @projects = Project.all.order(created_at: :desc)
  end

  def edit_project
    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project #{params[:id]} not found!"
      redirect_to '/'
    end
  end

  def update_project
    begin
      @project = Project.find(params[:id])
      @project[:title] = params[:title]
      @project[:description] = params[:description]
      @project[:content] = params[:content]
      @project[:image] = params[:image]
      @project.save
      flash[:notice] = 'Project saved'
      redirect_back(fallback_location: root_path)
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project #{params[:id]} not found!"
      redirect_to '/admin'
    rescue => e
      flash[:alert] = "Project #{params[:id]} not found!"
      redirect_back fallback_location: '/admin'
    end
  end

  def require_admin!
    authenticate_user!
    unless current_user.admin
      flash[:alert] = "You are not an admin"
      redirect_to '/'
    end
  end

end
