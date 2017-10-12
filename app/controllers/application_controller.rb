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
      flash[:message] = "Both fields must be completed."
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
    if !params["ship"]["type_class"].empty? && !params["ship"]["affiliation"].empty?
      @agent = Helpers.current_agent(session)
      # binding.pry

      @ship = Ship.create(params[:ship])

      @ship.agent_id = @agent.id
      @ship.save
      redirect "/all"
    else
      flash[:message] = "Confirm that all mandatory fields have been filled."
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
      redirect "/ship/#{@ship.id}"
    end
  end

  patch "/ship/:id" do
    # binding.pry
    if !params["ship"]["type_class"].empty? && !params["ship"]["affiliation"].empty?
      @ship = Ship.find_by(id: params[:id])
      @agent = Helpers.current_agent(session)
      
      @ship.update(params["ship"])
      @ship.agent_id = @agent.id
      @ship.save
      redirect "/all"
    else
      flash[:message] = "Confirm that all mandatory fields have been filled."
      redirect "/ship/#{@ship.id}/edit"
    end
  end

  get "/ship/:id/delete" do
    @agent = Helpers.current_agent(session)
    @ship = Ship.find_by(id: params[:id])
    # binding.pry
    if Helpers.is_logged_in?(session) && @ship.agent_id == @agent.id
      erb :delete
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ship/#{@ship.id}"
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
      redirect "/ship/#{@ship.id}"
    end
  end

  get "/ship/:id" do
    # binding.pry
    if Helpers.is_logged_in?(session)
      @ship = Ship.find_by(id: params[:id])
      @agent = Agent.find_by(id: @ship.agent_id)
      erb :ship
    else
      flash[:message] = "You must be logged in for this action."
      redirect "/login"
    end
  end

  get "/logout" do
    if Helpers.is_logged_in?(session)
      session.clear
      flash[:message] = "You have been logged out."
      redirect '/'
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
