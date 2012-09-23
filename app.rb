require 'rubygems'
require 'sinatra'
require 'haml'
require 'omniauth-clio'
require 'multi_json'

# Helpers
require './lib/render_partial'

# Set up Omniauth
# use Rack::Session::Cookie
enable :sessions
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
  haml :index, :layout => :'layouts/application'
end

get '/auth/clio/callback' do
	session['auth'] = request.env['omniauth.auth']
	session['token'] = session['auth']['credentials']['token']
	session['fb_error'] = nil
	# @token = auth['credentials']['token']
	# @name = auth['info']['first_name']
	# session['user'] = params[:name]
	redirect '/'
	# erb "<h1>#{params[:provider]}</h1>
 #    <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
end

get 'auth/failure' do
	"Authentigation failed: #{params}"
end	

get '/auth/:provider/deauthorized' do
	"#{params[:provider]} has deauthorized this app."
end

get '/logout' do
	clear_session
	redirect '/'
end

def clear_session
	session['auth'] = nil
	session['token'] = nil
	session['error'] = nil
end
