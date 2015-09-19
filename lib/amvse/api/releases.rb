module Amvse
  class Release
    attr_accessor :id, :website_id, :files
    
    def initialize(attributes={})
      self.id = attributes[:id]
      self.website_id = attributes[:website_id]
      self.files = attributes[:files].map{|file_json| ReleaseFile.new(file_json) } || []
    end
    
    def serialize
      data = { id: self.id, website_id: self.website_id, files: [] }
      data[:files] = self.files.map{|file| file.serialize }
      data
    end
    
  end
  
  class API

    def get_releases(website_id)
      json_string = request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites/#{website_id}/releases"
      ).body
      MultiJson.load(json_string).symbolize_keys.map do |response_object|
        Release.new response_object
      end
    end
    
    def get_release(website_id, id)
      json_string = request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites/#{website_id}/releases/#{id}"
      ).body
      Release.new MultiJson.load(json_string).symbolize_keys
    end

    def post_releases(website_id, release_params)
      json_string = request(
        :expects  => 201,
        :method   => :post,
        :path     => "/v1/websites/#{website_id}/releases",
        :body     => MultiJson.dump({release: release_params})
      ).body
      Release.new MultiJson.load(json_string).symbolize_keys
    end

    def delete_release(website_id, id)
      request(
        :expects  => 204,
        :method   => :delete,
        :path     => "/v1/websites/#{website_id}/releases/#{id}"
      )
    end

  end
end