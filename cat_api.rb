require 'httparty'

class CatAPI
    include HTTParty

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

    def self.get_categories
        categories = self.get("/categories/list", query: BASE_PARAMS)
        return categories['response']['data']['categories']['category']
    end

    def self.get_random_image
        response = self.get("/images/get", query: IMAGE_PARAMS)
        return response['response']['data']['images']['image']
    end

    def self.get_image_by_category(category)
        params = IMAGE_PARAMS.merge(category: category)
        response = self.get("/images/get", query: params)
        return response['response']['data']['images']['image']
    end

    def self.add_or_remove_favorite(session_id, image_id, add)
        action = add ? "add" : "remove"
        params = BASE_PARAMS.merge(sub_id: session_id, image_id: image_id, action: action)
        self.get("/images/favourite", query: params)
        return
    end

    def self.get_random_favorite(session_id)
        params = BASE_PARAMS.merge(sub_id: session_id)
        response = self.get("/images/getfavourites", query: params)
        images = response['response']['data']['images']['image']
        return images.length > 1 ? images.sample : images
    end

    def self.report_image(image_id)
        params = BASE_PARAMS.merge(image_id: image_id)
        response = self.get("/images/report", query: params)
        return
    end
end