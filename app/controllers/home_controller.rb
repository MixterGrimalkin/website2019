class HomeController < ApplicationController
  def index
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
