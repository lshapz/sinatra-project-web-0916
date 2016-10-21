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
  @user = User.create(params)
  redirect "/users/#{@user.id}"
end

get '/users/:id' do
  if User.find_by_id(params[:id]) == nil
      redirect to '/users/new'
      #redirect so user isn't confronted with an error page
  else
    @restaurants = Restaurant.all 
    @user = User.find(params[:id])
    @sortable = @user.user_restaurants.sort_by {|x| x.restaurant.name}
    #for future referance 
    @faveable = @user.restaurants.sort_by {|x| x.name}
    #for the "my favorites list"
    @tryable = []
          #creates the "to try list" (user_restaurants false)
        @sortable.each do |try|
            if try.been_there == false
              @tryable << try
            end  
        end  
    @goners = @sortable - @tryable 
    # creates "I've been here" list 
      #binding.pry
    @categories = @user.categories.sort_by {|x| x.name}.uniq
    #binding.pry
    erb :'/users/show'
  end 
end

get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb :'/users/edit'
end


  delete '/users/restaurants' do
    UserRestaurant.where(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id]).take.destroy
    redirect to "/users/#{params[:rest][:user_id]}"
  end 



patch '/users/beenthere' do 
  @rest = UserRestaurant.find_by(params[:rest])
  @rest.update(params[:also])
  #button to move from to_try to tried 
  id = params[:rest][:user_id]
  redirect to "/users/#{id}"

end 

post '/users/favorites' do
  UserFavorite.find_or_create_by(params[:rest])
  id = params[:rest][:user_id]
  going = UserRestaurant.find_or_create_by(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id])
  going.update(been_there: true)
  going.save
  #update via dropdown list of restaurants you haven't already favorited  
  redirect to "/users/#{id}"
end 


  delete '/users/unfavorites' do
  #dropdown list of restaurants you HAVE already favorited  
    UserFavorite.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).destroy_all 
    redirect to "/users/#{params[:user_id]}"
  end 

patch '/users/:id' do
  @user = User.find(params[:id])
  #updates the username 
  @user.name = params[:user][:name]
  @user.save
  redirect :"/users/#{@user.id}"
end

  delete '/users/:id/delete' do
    #make sure to clear IDs from joins tables to avoid future errors 
    UserRestaurant.where(user_id: params[:id]).destroy_all
    UserFavorite.where(user_id: params[:id]).destroy_all
    User.destroy(params[:id])
    redirect to "/users"
  end 


end
