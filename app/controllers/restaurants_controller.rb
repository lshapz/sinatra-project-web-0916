class RestaurantsController < ApplicationController

require_all ('app/adapters')

get '/restaurants' do
  rest = Restaurant.all
  if !Restaurant.all.empty?
    @last_id = Restaurant.last.id 
  end 
  #last_id is for the "New!" feature 
  @restaurants = rest.sort_by {|x| x.name}
  #alphabetizing 
  erb :'/restaurants/index'
end

post '/yelp' do
    YelpApi.search(params[:location], params[:search], limit: 10)
    redirect to "/restaurants"
end 

get '/restaurants/new' do
  caters = Category.all
  @catego = caters.sort_by {|x| x.name}
  #alphabetizing 
  erb :'/restaurants/new'
end

post '/restaurants' do
  @restaurant = Restaurant.create(params[:rest])
  if params[:cat] != nil 
    params[:cat].each do |category|
      new_cat = Category.find_or_create_by(id: category)
      @restaurant.categories << new_cat
    end 
  end 
    #prevents errors being thrown when no categories apply 
  redirect "/restaurants/#{@restaurant.id}"
end

get '/restaurants/:id' do
  #if 
  if Restaurant.find_by_id(params[:id]) == nil
      redirect to '/restaurants/new'
   #redirect so user isn't confronted with an error page
  else
    use = User.all
    @users = use.sort_by {|x| x.name}
    #alphabetize
    @restaurant = Restaurant.find(params[:id])
  end
    if @restaurant.user_restaurants
       @goers = @restaurant.user_restaurants.sort_by {|x| x.user.name}
       #alphabetized list of users who appear in user_restaurant table 
    end 
    if @restaurant.user_favorites
      @lovers = @restaurant.user_favorites.sort_by {|x| x.user.name}
      #alphabetized list of users who've faved here
    end 
      collect1 = []
      @restaurant.user_restaurants.each do |x| 
        collect1 << [x.user_id, x.been_there]
      end 
          collect2 = []
          collect3 = []
          collect1.each do |status| 
            if status.include?(true)
                collect2 << status[0]
            else
               collect3 << status[0]
            end
          end
      @interested = @users.select {|user| collect3.include?(user.id)}    
        #in join table, hasn't visited
      @been_there = @users.select {|user| collect2.include?(user.id)}
        #in join table because has visited 
      @new_visitors = (@users - @been_there)
        #everyone who hasn't visited, even if they've expressed interest
      @new_triers = (@new_visitors - @interested)
        #everyone who hasn't visited or expressed interest 
    #separates tried from want-to-try (same table just boolean!) for dropdown menus 
    collectfave = []
        @lovers.each do |x|
          collectfave <<  x.user_id 
        end 
    @unsure = @users.select {|user| collectfave.include?(user.id)}
    @no_fave = (@users - @unsure)
      #removes already-faved restaurants from add-to-fave dropdown menu
    erb :'/restaurants/show'
  
end

post '/restaurants/favorites' do
  UserFavorite.find_or_create_by(params[:rest])
  id = params[:rest][:restaurant_id]
  going = UserRestaurant.find_or_create_by(user_id: params[:rest][:user_id], restaurant_id: params[:rest][:restaurant_id])
  going.update(been_there: true) 
  going.save
  #update via dropdown list of users who haven't already favorited you 
  redirect to "/restaurants/#{id}"
end 

post '/restaurants/users/try' do
  if UserRestaurant.where(params).empty? 
    params[:been_there] = false
    UserRestaurant.create(params)
#this logic probably isn't necessary now that the list logic exists above? 
  end 
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end

post '/restaurants/users/tried' do
  gone = UserRestaurant.find_or_create_by(params)
  #finds or creates the join row with just user_id and restaurant_id
  gone.been_there = true
  #sets or updates the boolean of been_there
  gone.save
  id = params[:restaurant_id]
  redirect "/restaurants/#{id}"
end


get '/restaurants/:id/edit' do
  caters = Category.all
  @catego = caters.sort_by {|x| x.name}
  #need these because categories is a checklist of existing table and not new params entirely 
  @restaurant = Restaurant.find(params[:id])
  erb :'/restaurants/edit'
end

patch '/restaurants/:id' do
  @restaurant = Restaurant.find(params[:id])
  @restaurant.name = params[:restaurant][:name]
  @restaurant.address = params[:restaurant][:address]
  @restaurant.categories.clear 
  #I'm not sure if I like using .clear here - 
  #maybe set new_cat to blank array, iterate through it, check !@restaurants.categories.include?(new_cat_item), << ?
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
  #make sure to clear IDs from joins tables to avoid future errors - could also do with autosave: true in models  
  UserRestaurant.where(restaurant_id: params[:id]).destroy_all
  UserFavorite.where(restaurant_id: params[:id]).destroy_all
  RestaurantCategory.where(restaurant_id: params[:id]).destroy_all
  Restaurant.destroy(params[:id])
  redirect to "/restaurants"
end 

end
