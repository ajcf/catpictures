require 'httparty'

#
# interface with thecatapi.com's api for displaying cat photos
#
class CatAPI
    include HTTParty

    # pull config values from heroku's config settings, or config/application.yml
    if ENV['API_KEY'] and ENV['BASE_URL']
        API_KEY = ENV['API_KEY']
        BASE_URL = ENV['BASE_URL']
    else
        config = YAML.load_file("config/application.yml")
        API_KEY = config['api_key']
        BASE_URL = config['base_url']
    end

    base_uri BASE_URL
    format :xml
    BASE_PARAMS = {api_key: API_KEY}
    IMAGE_PARAMS = BASE_PARAMS.merge(format: "xml", size: "med")

    # returns a list of possible categories
    def self.get_categories
        categories = self.get("/categories/list", query: BASE_PARAMS)
        return categories['response']['data']['categories']['category']
    end

    # gets an image, with possible params such as "image_id" or "category"
    # if no params are passed, returns a random image
    def self.get_image(extra_params = {})
        params = IMAGE_PARAMS.merge(extra_params)
        response = self.get("/images/get", query: params)
        return response['response']['data']['images']['image']
    end

    # gets a random image from a user's favorited images
    def self.get_random_favorite(session_id)
        params = BASE_PARAMS.merge(sub_id: session_id)
        response = self.get("/images/getfavourites", query: params)
        images = response['response']['data']['images']['image']

        return ((images.is_a? Array) ? images.sample : images)
    end

    # adds or removes an image from the user's favorite list
    # "add" is a boolean, if "add" = false, the image is removed
    def self.add_or_remove_favorite(session_id, image_id, add = true)
        action = add ? "add" : "remove"
        params = BASE_PARAMS.merge(sub_id: session_id, image_id: image_id, action: action)
        self.get("/images/favourite", query: params)
        return
    end

    # sends a report about an image to thecatapi.com
    # this prevents that specific image from being rendered to this API key again.
    def self.report_image(image_id)
        params = BASE_PARAMS.merge(image_id: image_id)
        response = self.get("/images/report", query: params)
        return
    end
end