require './config/environment'

class ApplicationController < Sinatra::Base
  use Rack::Flash

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
    if !params['username'].empty? && !params['password'].empty?
      @agent = Agent.create(username: params[:username], password: params[:password])
      session[:id] = @agent.id # @agent is now logged in
      redirect "/all"
      @agent.save
    else
      # flash message about mandatory fields
      redirect "/signup"
    end
  end

  get "/new" do
    if Helpers.is_logged_in?(session)
      erb :new
    else
      flash[:message] = "You must be logged in to add a record."
      redirect "/login"
    end
  end

  post "/all" do
    if !params["type_class"].empty? && !params["affiliation"].empty?
      @agent = Helpers.current_agent(session)
      @ship = Ship.create(type_class: params["type_class"], top_speed: params["top_speed"], crew: params["crew"], affiliation: params["affiliation"])
      @ship.agent_id = @agent.id
      @ship.save
      redirect "/all"
    else
      # flash message about data validation
      redirect "/new"
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
      flash[:message] = "You must be logged in for this action."
      erb :login
    end
  end

  get "/all" do
    if Helpers.is_logged_in?(session)
      @ships = Ship.all
      erb :"/all"
    else
      flash[:message] = "You must be logged in for this action."
      redirect "/login"
    end
  end

  get "/ship/:id/edit" do
    @agent = Helpers.current_agent(session)
    @ship = Ship.find_by(id: params[:id])
    # binding.pry
    if Helpers.is_logged_in?(session) && @ship.agent_id == @agent.id
      erb :edit
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ship/:id"
    end
  end

  post "/ship/:id/edit" do
    # binding.pry
    if !params["type_class"].empty? && !params["affiliation"].empty?
      @ship = Ship.find_by(id=params[:id])
      @agent = Helpers.current_agent(session)
      @ship.update(type_class: params["type_class"], top_speed: params["top_speed"], crew: params["crew"], affiliation: params["affiliation"])
      @ship.agent_id = @agent.id
      @ship.save
      redirect "/all"
    end
  end

  get "/ship/:id/delete" do
    @agent = Helpers.current_agent(session)
    @ship = Ship.find_by(id: params[:id])
    if Helpers.is_logged_in?(session) && @ship.agent_id == @agent.id
      erb :delete
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ship/:id"
    end
  end

  post "/ship/:id/delete" do
    @agent = Helpers.current_agent(session)
    @ship = Ship.find_by(id: params[:id])
    # binding.pry
    if Helpers.is_logged_in?(session) && @ship.agent_id == @agent.id
      @ship.delete
      flash[:message] = "The record has been deleted."
      redirect "/all"
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ship/:id"
    end
  end

  get "/ship/:id" do
    # binding.pry
    if Helpers.is_logged_in?(session)
      @ship = Ship.find_by(id: params[:id])
      erb :ship
    else
      flash[:message] = "You must be logged in for this action."
      redirect "/login"
    end
  end

  get "/logout" do
    if Helpers.is_logged_in?(session)
      session.clear # @agent is now logged out
    end
    flash[:message] = "You have been logged out."
    redirect '/'
  end

  get "/" do
    erb :welcome
  end

  not_found do
    status 404
    erb :custom_error
  end

end
