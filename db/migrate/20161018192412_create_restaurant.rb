class CreateRestaurant < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
       t.string :name
       t.float :rating
       t.string :address
       t.string :spec_address
       t.string :url
       t.string :deals
       t.string :deals_title
       t.string :deals_url
       t.string :yelp_id 
    end 
  end
end
