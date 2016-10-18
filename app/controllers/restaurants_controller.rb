class RestaurantsController < ApplicationController



get '/restaurants' do
  @restaurants = Restaurant.all
  erb :'/restaurants/index'
end


post '/yelp' do
    #CALL THE YELP API   
    #params[:limit] = 10
    #binding.pry
    response = Yelp.client.search(params[:location], term: params[:term], limit: 10) 
    response.businesses.each do |business|
      Restaurant.create(name: business.name, address: business.location.address, rating: business.rating)
    end 
    #{}"https://api.yelp.com/v2/search?term=#{params[:term]}&location=#{params[:location]}&limit=10"



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
  @rest = Restaurant.find(params[:id])
  @users = User.all
  erb :'/restaurants/show'
end

post '/tryme' do
  UserRestaurant.create(params)
  #binding.pry
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end

get '/restaurants/:id/edit' do
  @restaurant = Restaurant.find(params[:id])
  erb :'/restaurants/edit'
end

post '/restaurants/:id' do
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
