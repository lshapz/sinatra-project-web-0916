class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set(:views, 'app/views')

# use Rack::Auth::Basic, "Restricted Area" do |username, password|
#   username == 'admin' and password == 'admin'
# end
require 'sinatra'

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['password', 'admin']
  end
end

get '/protected' do
  protected!
  "Welcome, authenticated client"
end

get '/' do 
  erb :'index', :layout => false
end

end