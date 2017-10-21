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
    if is_logged_in?
      redirect "/all"
    else
      erb :signup
    end
  end

  post "/signup" do
    if Agent.find_by(username: params['username'])
      flash[:message] = "Username already exists."
      redirect "/signup"
    elsif !params['username'].empty? && !params['password'].empty?
      @agent = Agent.create(username: params[:username], password: params[:password])
      session[:agent_id] = @agent.id
      redirect "/ships"
    else
      flash[:message] = "Both fields must be completed."
      redirect "/signup"
    end
  end

  get "/new" do
    if is_logged_in?
      erb :new
    else
      flash[:message] = "You must be logged in to add a record."
      redirect "/login"
    end
  end

  post "/ships" do
    if !params["ship"]["type_class"].empty? && !params["ship"]["affiliation"].empty?
      @ship = Ship.create(params[:ship])
      @ship.agent_id = current_agent.id
      @ship.save
      redirect "/ships"
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
      session[:agent_id] = @agent.id # @agent is now logged in
      redirect '/ships'
    else
      flash[:message] = "You must be logged in for this action."
      erb :login
    end
  end

  get "/ships" do
    if is_logged_in?
      @ships = Ship.all
      erb :"/index"
    else
      flash[:message] = "You must be logged in for this action."
      redirect "/login"
    end
  end

  get "/ships/:id/edit" do
    @ship = Ship.find_by(id: params[:id])
    if is_logged_in? && @ship.agent_id == current_agent.id
      erb :edit
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ships/#{@ship.id}"
    end
  end

  patch "/ships/:id" do
    if !params["ship"]["type_class"].empty? && !params["ship"]["affiliation"].empty?
      @ship = Ship.find_by(id: params[:id])
      
      @ship.update(params["ship"])
    
      redirect "/ships"
    else
      flash[:message] = "Confirm that all mandatory fields have been filled."
      redirect "/ships/#{@ship.id}/edit"
    end
  end

  get "/ships/:id/delete" do
    @agent = current_agent
    @ship = Ship.find_by(id: params[:id])
    if is_logged_in? && @ship.agent_id == @agent.id
      erb :delete
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ships/#{@ship.id}"
    end
  end

  post "/ships/:id/delete" do
    @agent = current_agent
    @ship = Ship.find_by(id: params[:id])
    if is_logged_in? && @ship.agent_id == @agent.id
      @ship.delete
      flash[:message] = "The record has been deleted."
      redirect "/ships"
    else
      flash[:message] = "This action is unauthorized (belongs to another agent)."
      redirect "/ships/#{@ship.id}"
    end
  end

  get "/ships/:id" do
    if is_logged_in?
      if @ship = Ship.find_by(id: params[:id])
        erb :show
      else 
        flash[:message] = "A ship with the id of #{params[:id]} does not exist!"
        redirect to '/ships'
      end
    else
      flash[:message] = "You must be logged in for this action."
      redirect "/login"
    end
  end

  get "/logout" do
    if is_logged_in?
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

  helpers do 
    def current_agent
      Agent.find_by(id: session[:agent_id])
    end

    def is_logged_in?
      !!current_agent
    end
  end

end
