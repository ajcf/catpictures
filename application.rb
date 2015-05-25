require 'sinatra'
require 'securerandom'
require_relative 'cat_api'

##################### Configuration #####################

# load secret key from application.yml unless deploying to heroku
if ENV['SECRET']
    SECRET = ENV['SECRET']
else
    SECRET = YAML.load_file("config/application.yml")['secret']
end

# enable user sessions to support favoriting photos
enable :sessions
set :session_secret, SECRET

# pull a list of categories from the API
def _build_category_list
    raw_categories = CatAPI.get_categories
    category_list = raw_categories.map {|category| category['name']}.sort
    # the "kittens" category is empty, and never returns photos
    category_list.delete("kittens")
    return category_list.unshift("favorites")
end
CATEGORIES = _build_category_list

######################## Routing ########################

# default route - displays a random cat picture, or finds one by ID
get '/' do
    session['unique_id'] = SecureRandom.hex(10) unless session['unique_id']

    if params[:id]
        @image = CatAPI.get_image(image_id: params[:id])
    else
        @image = CatAPI.get_image
    end
    @local_url = _get_local_url(@image, request)
    @categories = CATEGORIES
    @unique_id = session['unique_id']

    erb :index
end

# fetches a cat picture for a given category name, or "random"
get "/category/:category" do |category|
    if category == "favorites"
        @image = CatAPI.get_random_favorite(session[:unique_id])
    elsif CATEGORIES.include? category
        @image = CatAPI.get_image(category: category)
    else
        @image = CatAPI.get_image
    end
    @local_url = _get_local_url(@image, request)
    erb :cat_photo
end

# gets a random image from the current user's favorites
get "/favorites" do 
    CatAPI.get_favorites(session[:unique_id])
end

# adds an image to the current user's favorites
get "/favorite/:image_id" do |image_id|
    CatAPI.add_or_remove_favorite(session[:unique_id], image_id, true)
end

# reports an image to thecatapi.com
get "/report/:image_id" do |image_id|
    CatAPI.report_image(image_id)
end

##### helpers #######

def _get_local_url(image, request)
    "#{request.base_url}?id=#{image['id']}"
end