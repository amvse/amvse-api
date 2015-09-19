module Amvse
  class Release
    attr_accessor :id, :website_id, :files
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.website_id = attributes['website_id']
      self.files = attributes['files'].map{|file_json| Amvse::File.new(file_json) } || []
    end
    
    def serialize
      data = { 'id': self.id, 'website_id': self.website_id, 'files': [] }
      data['files'] = self.files.map{|file| file.serialize }
      data
    end
    
  end
  
  class API

    def get_releases(website_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites/#{website_id}/releases"
      ).body.map do |response_object|
        Amvse::Release.new response_object
      end
    end
    
    def get_release(website_id, id)
      Amvse::Release.new request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites/#{website_id}/releases/#{id}"
      ).body
    end

    def post_releases(website_id, release_params)
      Amvse::Release.new request(
        :expects  => 201,
        :method   => :post,
        :path     => "/v1/websites/#{website_id}/releases",
        :body     => {release: release_params}
      ).body
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