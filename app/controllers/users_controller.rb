class UsersController < ApplicationController

get '/users' do 
  @users = User.all 
  erb :'users/index'
end 


get '/users/new' do 
  erb :'users/new'
end 


post '/users' do 
  @user = User.create(params)
  redirect "/users/#{@user.id}"
end 



get '/users/:id' do 
  @user = User.find(params[:id])
  erb :'users/show'
end 


end 