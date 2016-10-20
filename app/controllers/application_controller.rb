
class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set(:views, 'app/views')


get '/' do 
  erb :'index', :layout => false
end

end