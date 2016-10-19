class RestaurantsController < ApplicationController

require_all ('app/adapters')

get '/restaurants' do
  @restaurants = Restaurant.all
  erb :'/restaurants/index'
end

post '/yelp' do
    #CALL THE YELP API   
    #params[:limit] = 10
    #binding.pry
    YelpApi.search(params[:location], params[:search], limit: 10)
    #binding.pry
    redirect to "/restaurants"
end 

get '/restaurants/new' do
  erb :'/restaurants/new'
end

post '/restaurants' do
  @restaurant = Restaurant.create(params)
  redirect "/restaurants/#{@restaurant.id}"
end

get '/restaurants/:id' do
  #if 
  if Restaurant.find_by_id(params[:id]) == nil
      redirect to '/restaurants/new'
  else
    @users = User.all
    @restaurant = Restaurant.find(params[:id])
    erb :'/restaurants/show'
  end
end

post '/restaurants/users' do
  #binding.pry
  if UserRestaurant.where(params).empty? 
    params[:been_there] = false
    UserRestaurant.create(params)
  end 
  #binding.pry
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end

get '/restaurants/:id/edit' do
  @restaurant = Restaurant.find(params[:id])
  erb :'/restaurants/edit'
end

patch '/restaurants/:id' do
  @restaurant = Restaurant.find(params[:id])
  @restaurant.name = params[:restaurant][:name]
  @restaurant.address = params[:restaurant][:address]
  @restaurant.rating = params[:restaurant][:rating]
  @restaurant.save
  redirect :"/restaurants/#{@restaurant.id}"
end



  delete '/restaurants/:id/delete' do
    #binding.pry
    Restaurant.destroy(params[:id])
    redirect to "/restaurants"
  end 

end
