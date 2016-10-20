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