class CreateUserFavorite < ActiveRecord::Migration
  def change
    create_table :user_favorites do |t|
      t.integer :user_id
      t.integer :restaurant_id
    end 
  end
end
