require 'bundler/setup'
Bundler.require

require_all('app/')

set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
require 'yelp'

Yelp.client.configure do |config|
  config.consumer_key = '7hbgP6jhhYxUjL5GeBYg1Q'
  config.consumer_secret = 'svXs_alxqjv2bovnQg6NlJOwIS4'
  config.token = 'rlP5-dh4uvdjnDsoUFsuIiJL_0bqO0zJ'
  config.token_secret = 'nnBWught5kfiLKrFzhwu98-3Uo8'
end


require 'rubygems'
require 'sinatra/base'
require 'active_record'
require 'sinatra/simple-authentication'
require 'rack-flash'

  use Rack::Flash, :sweep => true
  register Sinatra::SimpleAuthentication



