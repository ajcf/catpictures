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
    BASE_PARAMS = {api_key: API_KEY, format: "xml", size: "med"}

    def self.get_categories
        categories = self.get("/categories/list", query: BASE_PARAMS)
        return categories['response']['data']['categories']['category']
    end

    def self.get_random_image
        response = self.get("/images/get", query: BASE_PARAMS)
        return response['response']['data']['images']['image']
    end

    def self.get_image_by_category(category)
        params = BASE_PARAMS.merge(category: category)
        response = self.get("/images/get", query: params)
        return response['response']['data']['images']['image']
    end
end