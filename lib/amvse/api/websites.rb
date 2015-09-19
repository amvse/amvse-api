module Amvse
  class Website
    attr_accessor :id, :domain_name, :releases, :current_release_id
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.domain_name = attributes['domain_name']
      self.releases = (attributes['releases'] || []).map{|release_json| Amvse::Release.new(release_json) }
      self.current_release_id = attributes['current_release_id']
    end
    
    def serialize
      data = { 'id': self.id, 'domain_name': self.domain_name, 'current_release_id': self.current_release_id, 'releases': [] }
      data['releases'] = self.releases.map{|release| release.serialize }
      data
    end
    
  end
  
  class API

    def get_websites
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites"
      ).body.map do |website_object|
        Amvse::Website.new website_object
      end
    end
    
    def get_website(id)
      Amvse::Website.new request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites/#{id}"
      ).body
    end

    def put_website(id, website_params)
      Amvse::Website.new request(
        :expects  => 200,
        :method   => :put,
        :path     => "/v1/websites/#{id}",
        :body     => {website: website_params}
      ).body
    end

  end
end