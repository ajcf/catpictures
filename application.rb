require 'sinatra'
require 'securerandom'
require_relative 'cat_api'

enable :sessions
set :sessin_secret, YAML.load_file("config/application.yml")['secret']

CATEGORIES = CatAPI.get_categories

get '/' do
	session['unique_id'] = SecureRandom.hex(10) unless session['unique_id']

	@categories = CATEGORIES.map {|category| category['name']}
	@image = CatAPI.get_random_image
	@unique_id = session['unique_id']
	erb :index
end

get "/category/:category" do |category|
	CatAPI.get_image_by_category(category)['url']
end