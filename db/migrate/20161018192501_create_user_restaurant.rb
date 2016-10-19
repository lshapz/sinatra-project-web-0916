class CreateUserRestaurant < ActiveRecord::Migration
  def change
    create_table :user_restaurants do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.boolean :been_there
    end 
  end
end
