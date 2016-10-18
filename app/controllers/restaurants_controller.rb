class RestaurantsController < ApplicationController



get '/restaurants' do 
  @restaurants = Restaurant.all 
  erb :'restaurants/index'
end 


get '/restaurants/new' do 
  erb :'restaurants/new'
end 

post '/restaurants' do 
  @restaurant = Restaurant.create(params)
  redirect "/restaurants/#{@restaurant.id}"
end 

get '/restaurants/:id' do 
  @rest = Restaurant.find(params[:id])
  @users = User.all 
  erb :'restaurants/show'
end 

post '/tryme' do 
  UserRestaurant.create(params)
  #binding.pry 
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end 

end 