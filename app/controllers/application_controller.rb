class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set(:views, 'app/views')

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'admin' and password == 'admin'
end

get '/' do 
  erb :'index', :layout => false
end

end