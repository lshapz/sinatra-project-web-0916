require_relative 'config/environment'

use Rack::MethodOverride 
use UsersController
use CategoriesController
use RestaurantsController
run ApplicationController

root = File.dirname(__FILE__)
require File.join( root, 'index' )

run Rack::URLMap.new({
  "/"   => Index
})
