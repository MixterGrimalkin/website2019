class HomeController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @projects = Project.all.order(updated_at: :desc)
  end

  def project
    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project #{params[:id]} not found!"
      redirect_to '/'
    end
  end

  def contact_me
    data = {}
    data[:from] = "#{params[:name]} <#{params[:email]}>"
    data[:reply_to] = params[:email]
    data[:to] = 'barrimason@amarantha.net'
    data[:subject] = 'Message via website'
    data[:text] = params[:message]
    RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}@api.eu.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/messages", data
  end

end
