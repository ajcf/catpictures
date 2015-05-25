require 'httparty'

class CatAPI
    include HTTParty

    config = YAML.load_file("config/application.yml")

    base_uri config['base_url']
    format :xml
    BASE_PARAMS = {api_key: config['api_key'], format: "xml", size: "med"}

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