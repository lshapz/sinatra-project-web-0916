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
      redirect to '/categories/new'
       #redirect so user isn't confronted with an error page
  else
    @category = Category.find(params[:id])
    resting = @category.restaurants
    @rest = resting.sort_by {|x| x.name}
    user = @category.users
    @users = user.sort_by {|x| x.name}.uniq 
  #needs uniq because it has_many through which means no find_or_create invoked - HTK look up if there's an AR fix
    erb :'/categories/show'
  end 
end

get '/categories/:id/edit' do
  @category = Category.find(params[:id])
  erb :'/categories/edit'
end

patch '/categories/:id' do
  @category = Category.find(params[:id])
  @category.name = params[:cat][:name]
  @category.save
  redirect :"/categories/#{@category.id}"
end

post '/category' do 
  @category = Category.find_or_create_by(params[:cat])
  id = @category.id
  redirect to "/categories/#{id}"
end

  delete '/categories/:id/delete' do
  #make sure to clear IDs from joins tables to avoid future errors 
    RestaurantCategory.where(category_id: params[:id]).destroy_all
    Category.destroy(params[:id])
    redirect to "/categories"
  end 
end 