require 'rubygems'
require 'sinatra'
require 'haml'
require 'omniauth-clio'
require 'httparty'
require 'jsonify'
require 'jsonify/tilt'

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
	create_json_client
	token = session['token']
  auth = "Bearer " + token
  @post = HTTParty.post("https://app.goclio.com/api/v1/contacts", :headers => { "Authorization" => auth, 'Content-Type' => 'application/json'}, :body => {'contact' => @client})
	haml :review, :layout => :'layouts/application'
end

# Clio API Methods
# def get_activities - Just a test to get HTTParty working
# 	token = session['token']
#   auth = "Bearer " + token
#   user = HTTParty.get("https://app.goclio.com/api/v1/activities", :headers => { "Authorization" => auth})
#   @activities = user['activities']
# end

# Create Json for Posting
def create_json_client
	json = Jsonify::Builder.new
	json.client do # start a new JsonObject 
  	json.type "Person" 
  	json.first_name "#{params[:first_name]}"
  	json.last_name "#{params[:last_name]}"
  end
  @client = json.compile!
end









