class CategoriesController < ApplicationController

get '/categories' do
  cat = Category.all
  @categories  = cat.sort_by {|x| x.name}
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
    @category = Category.find(params[:id])
    resting = @category.restaurants
    @rest = resting.sort_by {|x| x.name}
    user = @category.users
    @users = user.sort_by {|x| x.name}.uniq
    erb :'/categories/show'
  end 
end

get '/categories/:id/edit' do
  @category = Category.find(params[:id])
  erb :'/categories/edit'
end

patch '/categories/:id' do
  @category = Category.find(params[:id])
  #binding.pry
  @category.name = params[:cat][:name]
  @category.save
  redirect :"/categories/#{@category.id}"
end

post '/category' do 
  #binding.pry
  @category = Category.find_or_create_by(params[:cat])
  id = @category.id
  redirect to "/categories/#{id}"
end

  delete '/categories/:id/delete' do
    #binding.pry 
    RestaurantCategory.where(category_id: params[:id]).destroy_all
    Category.destroy(params[:id])
    redirect to "/categories"
  end 
end 