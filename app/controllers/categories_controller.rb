class UsersController < ApplicationController

get '/categories' do
  @categories = Category.all
  erb :'/categories/index'
end

get '/categories/new' do
 @categories = Category.all 
    erb :'/categories/new'
end 


get '/categories/:id' do
  if Category.find_by_id(params[:id]) == nil
      redirect to '/categories/index'
  else
    @restaurants = Restaurant.all 
    @category = Category.find(params[:id])
    erb :'/categories/show'
  end 
end


post '/category' do 
  #binding.pry
  @category = Category.find_or_create_by(params[:cat])
  id = @category.id
  redirect to "/categories/#{id}"
end

end 