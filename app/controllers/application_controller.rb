require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get "/signup" do
    if Helpers.is_logged_in?(session)
      redirect "/all"
    else
      erb :signup
    end
  end

  post "/signup" do
    @agent = Agent.create(username: params[:username], password: params[:password])
    session[:id] = @agent.id # @agent is now logged in
    redirect "/all"
  end

  get "/new" do
    erb :new
  end

  post "/all" do
    if !params["type_class"].empty? && !params["affiliation"].empty?
      Ship.create(type_class: params["type_class"], top_speed: params["top_speed"], crew: params["crew"], affiliation: params["affiliation"])
      redirect "/all"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    @agent = Agent.find_by(username: params["username"])

    if @agent && @agent.authenticate(params[:password])
      session[:id] = @agent.id # @agent is now logged in
      redirect '/all'
    else
      erb :login
    end
  end

  get "/all" do
    if Helpers.is_logged_in?(session)
      @ships = Ship.all
      erb :"/all"
    else
      redirect "/login"
    end
  end

  get "/show/:id" do
    if Helpers.is_logged_in?(session)
      @ship = Ship.find_by(id: params[:id])
      erb :show
    else
      redirect "/login"
    end
  end

  get "/" do
    erb :welcome
  end

  not_found do
    status 404
    erb :custom_error
  end

end
