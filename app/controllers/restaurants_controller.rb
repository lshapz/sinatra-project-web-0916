class RestaurantsController < ApplicationController

require_all ('app/adapters')

get '/restaurants' do
  rest = Restaurant.all
  if !Restaurant.all.empty?
    @last_id = Restaurant.last.id 
  end 

  # @restaurants = []
  # rester = rest.sort_by {|x| x.name}
  # rester.delete_if {|thing| thing.id + 10 >= @last_id}
  # selection = rest.select {|thing| thing.id + 10 >= @last_id}
  # @restaurants = rester
  # selection.each {|x| @restaurants.unshift(x)} 
  # @restaurants
  @restaurants = rest.sort_by {|x| x.name}

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
  caters = Category.all
  @catego = caters.sort_by {|x| x.name}
  erb :'/restaurants/new'
end

post '/restaurants' do
  @restaurant = Restaurant.create(params[:rest])
  #binding.pry
  if params[:cat] != nil 
    params[:cat].each do |category|
      new_cat = Category.find_or_create_by(id: category)
      @restaurant.categories << new_cat
    end 
  end 

  #YelpApi.search(location: params[:rest][:address], terms: params[:rest], limit: {limit: 1})
  # rest = Restaurant.last
  # id = rest.id
   #Category.find_or_create_by(params[:cat])
  #@restaurant.categories = []

  redirect "/restaurants/#{@restaurant.id}"
end

get '/restaurants/:id' do
  #if 
  if Restaurant.find_by_id(params[:id]) == nil
      redirect to '/restaurants/new'
  else
    use = User.all
    @users = use.sort_by {|x| x.name}
    @restaurant = Restaurant.find(params[:id])
    @goers = @restaurant.user_restaurants.sort_by {|x| x.user.name}
    @lovers = @restaurant.user_favorites.sort_by {|x| x.user.name}
    erb :'/restaurants/show'
  end
end

post '/restaurants/users/try' do
  #binding.pry
  if UserRestaurant.where(params).empty? 
    params[:been_there] = false
    UserRestaurant.create(params)
  end 
  #binding.pry
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end


post '/restaurants/users/tried' do
  #binding.pry
  gone = UserRestaurant.find_or_create_by(params)
  gone.been_there = true
  gone.save
  
  #binding.pry
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end


get '/restaurants/:id/edit' do
  caters = Category.all
  @catego = caters.sort_by {|x| x.name}
  @restaurant = Restaurant.find(params[:id])
  erb :'/restaurants/edit'
end

patch '/restaurants/:id' do
  @restaurant = Restaurant.find(params[:id])
  @restaurant.name = params[:restaurant][:name]
  @restaurant.address = params[:restaurant][:address]
  #binding.pry
  @restaurant.categories.clear 
  if params[:cat] != nil 
    params[:cat].each do |category|
      new_cat = Category.find_or_create_by(id: category)
      @restaurant.categories << new_cat
    end 
  end 
  @restaurant.save
  redirect :"/restaurants/#{@restaurant.id}"
end



  delete '/restaurants/:id/delete' do
    #binding.pry 
    UserRestaurant.where(restaurant_id: params[:id]).destroy_all
    UserFavorite.where(restaurant_id: params[:id]).destroy_all
    RestaurantCategory.where(restaurant_id: params[:id]).destroy_all
    Restaurant.destroy(params[:id])
    redirect to "/restaurants"
  end 

end
