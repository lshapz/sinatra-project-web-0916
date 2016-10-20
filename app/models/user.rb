class User < ActiveRecord::Base
  has_many :user_restaurants 
  has_many :user_favorites 
# has_many :restaurants, through: :user_restaurants
  has_many :restaurants, through: :user_favorites
  has_many :categories, through: :restaurants
end 