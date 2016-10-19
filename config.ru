require_relative 'config/environment'

use Rack::MethodOverride 
use UsersController
use CategoriesController
use RestaurantsController
run ApplicationController
