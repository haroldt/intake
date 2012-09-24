require 'rubygems'
require 'sinatra'
require 'haml'
require 'omniauth-clio'
require 'httparty'
require 'rack-flash'

# Set up Omniauth
enable :sessions
use Rack::Session::Cookie
use Rack::Flash
use OmniAuth::Builder do
  provider :clio, ENV['CLIO_CLIENT_KEY'], ENV['CLIO_CLIENT_SECRET'] 
end


# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
set :public_folder, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml

# Application routes
get '/' do
  unless session['token'].nil?
    get_activities
    haml :index, :layout => :'layouts/application'
  else
    haml :show, :layout => :'layouts/application'
  end
end

get '/auth/clio/callback' do
  auth = request.env['omniauth.auth']
  token = auth['credentials']['token']
  session['token'] = token
  redirect '/'
end

get '/logout' do
	session['token'] = nil
	redirect '/'
end

get '/auth/failure' do
	flash[:error] = "Authentication Failed: You will need to reauthenticate"
	redirect '/'  
end

get '/auth/clio/deauthorized' do
	flash[:error] = "Authentication Failed: You will need to reauthenticate"
	redirect '/'
end

# Clio API Methods
def get_activities
	token = session['token']
  auth = "Bearer " + token
  user = HTTParty.get("https://app.goclio.com/api/v1/activities", :headers => { "Authorization" => auth})
  @posts = user['activities']
end






















