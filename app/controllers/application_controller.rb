require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    @user = User.create(name: params[:username], password: params[:password])
    redirect "/main"
  end

  get "/login" do
    erb :login
  end

  get "/main" do
    # if logged in
    erb :main
    # else, redirect to /login
  end

  get "/" do
    erb :welcome
  end

  post "/main" do

    erb :main
  end

  not_found do
    status 404
    erb :custom_error
  end

end
