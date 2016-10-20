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
  end
  #binding.pry
    if @restaurant.user_restaurants
       @goers = @restaurant.user_restaurants.sort_by {|x| x.user.name}
    end 
    if @restaurant.user_favorites
      @lovers = @restaurant.user_favorites.sort_by {|x| x.user.name}
    end 
      collect1 = []
      @restaurant.user_restaurants.each do |x| 
        collect1 << [x.user_id, x.been_there]
      end 
          collect2 = []
          collect3 = []
          collect1.each do |status| 
            #q << y[0]
            if status.include?(true)
                collect2 << status[0]
            else
               collect3 << status[0]
            end
          end
      @maybe = @users.select {|user| collect3.include?(user.id)}    
      @why = @users.select {|user| collect2.include?(user.id)}
      #binding.pry
      @new_visitors = (@users - @why)
      @new_triers = (@new_visitors - @maybe)
    
    collectfave = []
        @restaurant.user_favorites.each do |x|
          collectfave <<  x.user_id 
        end 
    @sure = @users.select {|user| collectfave.include?(user.id)}
    @no_fave = (@users - @sure)
        
    erb :'/restaurants/show'
  
end

post '/restaurants/favorites' do
  #binding.pry 
  UserFavorite.find_or_create_by(params[:rest])
  id = params[:rest][:restaurant_id]
  going = UserRestaurant.find_or_create_by(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id])
  going.update(been_there: true) 
  going.save
  redirect to "/restaurants/#{id}"
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
  #binding.pry
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
