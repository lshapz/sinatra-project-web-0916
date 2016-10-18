class UsersController < ApplicationController

get '/users' do
  @users = User.all
  erb :'/users/index'
end


get '/users/new' do
  erb :'/users/new'
end


post '/users' do
  @user = User.create(params)
  redirect "/users/#{@user.id}"
end

get '/users/:id' do
  if User.find_by_id(params[:id]) == nil
      redirect to '/users/new'
  else
    @user = User.find(params[:id])
    erb :'/users/show'
  end 
end

get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb :'/users/edit'
end

post '/users/:id' do
  @user = User.find(params[:id])
  @user.name = params[:user][:name]
  @user.save
  redirect :"/users/#{@user.id}"
end

  delete '/users/:id/delete' do
    #binding.pry
    User.destroy(params[:id])
    redirect to "/users"
  end 


  delete '/users/no_try' do
    UserRestaurant.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).destroy_all 
    #binding.pry
    redirect to "/users/#{params[:user_id]}"
  end 

end
