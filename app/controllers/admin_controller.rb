class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :require_admin!

  def index
    @projects = Project.all.order(title: :asc)
  end

  def new_project
    @project = Project.new
    render :edit_project
  end

  def edit_project
    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project '#{params[:id]}' not found!"
      redirect_to '/'
    end
  end

  def create_project
    project = Project.create!(
        {
            title: params[:title],
            description: params[:description],
            content: params[:content],
            image: params[:image]
        }
    )
    flash[:notice] = 'Project created'
    redirect_to "/project/#{project.id}/edit"
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

  def delete_project
    begin
      project = Project.find(params[:id])
      project.destroy
      flash[:notice] = 'Project deleted'
      redirect_to '/admin'
    rescue
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
