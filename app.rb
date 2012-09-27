require 'rubygems'
require 'sinatra'
require 'haml'
require 'omniauth-clio'
require 'httparty'

# Set up Omniauth
enable :sessions
use Rack::Session::Cookie
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
	@values = {}
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
	@values = {}
	session['token'] = nil
	redirect '/'
end

get '/auth/failure' do
	redirect '/'  
end

get '/auth/clio/deauthorized' do
	redirect '/'
end

post '/' do
	@values = params
	haml :review, :layout => :'layouts/application'
end

# Clio API Methods
def get_activities
	token = session['token']
  auth = "Bearer " + token
  user = HTTParty.get("https://app.goclio.com/api/v1/activities", :headers => { "Authorization" => auth})
  @activities = user['activities']
end

















