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
    @restaurants = Restaurant.all 
    @user = User.find(params[:id])
    erb :'/users/show'
  end 
end

get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb :'/users/edit'
end

patch '/users/:id' do
  @user = User.find(params[:id])
  #binding.pry
  @user.name = params[:user][:name]
  @user.save
  redirect :"/users/#{@user.id}"
end

post '/users/favorites' do
  UserFavorite.create(params)
  id = params[:user_id]
  redirect to "/users/#{id}"
end 

  delete '/users/:id/delete' do
    #binding.pry
    User.destroy(params[:id])
    redirect to "/users"
  end 

  delete '/users/restaurants' do
    UserRestaurant.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).destroy_all 
    #binding.pry
    redirect to "/users/#{params[:user_id]}"
  end 

  delete '/users/unfavorite' do
    UserFavorite.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).destroy_all 
    redirect to "/users/#{params[:user_id]}"

  end 

end
