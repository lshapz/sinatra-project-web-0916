class RestaurantsController < ApplicationController



get '/restaurants' do
  @restaurants = Restaurant.all
  erb :'/restaurants/index'
end


post '/yelp' do
    #CALL THE YELP API   
    #params[:limit] = 10
    #binding.pry
    response = Yelp.client.search(params[:location], params[:search], limit: 10) 
    #binding.pry
    response.businesses.each do |business|
      rest = Restaurant.find_or_create_by(address: business.location.address[0])
      rest.name = business.name
      rest.rating = business.rating 
      rest.url = business.url 
      #binding.pry
      if business.deals != nil
        rest.deals = business.deals
        business.deals.each {|deal| deal.options.each {|option| rest.deals_title = option.title}}
        business.deals.each {|deal| deal.options.each {|option| rest.deals_url = option.purchase_url}}
      end 
      rest.save
    end 
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
  UserRestaurant.create(params)
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
