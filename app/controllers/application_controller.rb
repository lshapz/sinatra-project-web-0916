
require 'sinatra/simple-authentication'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "db/database.sqlite3")
  use Rack::Flash, :sweep => true
  register Sinatra::SimpleAuthentication


  set(:views, 'app/views')

get '/' do 
  login_required
  erb :'index', :layout => false
end
# run Rack::URLMap.new({
#   "/"  => erb :'index'
# })




end