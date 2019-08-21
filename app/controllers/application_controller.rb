class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  # render the sign-up form view.
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  # responsible for handling the POST request that is sent when a user hits 'submit' on the sign-up form
  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id

    redirect '/users/home'
  end

  # is responsible for rendering the login form
  get '/sessions/login' do
    erb :'sessions/login'
  end

  # This route is responsible for receiving the POST request that gets sent when a user hits 'submit' on the login form.
  # find the correct user from the database and log them in
  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  # This route is responsible for logging the user out by clearing the session hash.
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  # This route is responsible for rendering the user's homepage view.
  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end

end
