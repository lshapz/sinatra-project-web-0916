class AddMoreToRestaurants < ActiveRecord::Migration
  def change
      add_column :restaurants, :deals, :string
      change_column :restaurants, :rating, :float
  end
end
