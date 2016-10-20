class UsersController < ApplicationController

get '/users' do
  use = User.all
  @users = use.sort_by {|x| x.name}
  erb :'/users/index'
end


get '/users/new' do
  erb :'/users/new'
end


post '/users' do
  protected!

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


  delete '/users/restaurants' do
    #binding.pry
        protected!

    UserRestaurant.where(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id]).take.destroy
    #binding.pry
    ##binding.pry
    redirect to "/users/#{params[:rest][:user_id]}"
  end 

  delete '/users/unfavorite' do
        protected!

    UserFavorite.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).take.destroy 
    redirect to "/users/#{params[:user_id]}"

  end 


patch '/users/beenthere' do 
      protected!

  @rest = UserRestaurant.find_by(params[:rest])
  @rest.update(params[:also])
  id = params[:rest][:user_id]
  redirect to "/users/#{id}"

end 

post '/users/favorites' do
      protected!

  UserFavorite.create(params[:rest])
  id = params[:rest][:user_id]
  going = UserRestaurant.find_or_create_by(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id])
  going.update(been_there: true)
  redirect to "/users/#{id}"
end 

patch '/users/:id' do
      protected!

  @user = User.find(params[:id])
  #binding.pry
  @user.name = params[:user][:name]
  @user.save
  redirect :"/users/#{@user.id}"
end

  delete '/users/:id/delete' do
    #binding.pry
        protected!

    UserRestaurant.where(user_id: params[:id]).destroy_all
    UserFavorite.where(user_id: params[:id]).destroy_all
    User.destroy(params[:id])
    redirect to "/users"
  end 


end
