module Amvse
  class ReleaseFile
    attr_accessor :id, :website_id, :release_id, :md5, :bytes, :path, :s3_form_data
    
    def initialize(attributes={})
      self.id = attributes[:id]
      self.website_id = attributes[:website_id]
      self.release_id = attributes[:release_id]
      self.md5 = attributes[:md5]
      self.bytes = attributes[:bytes]
      self.path = attributes[:path]
      self.s3_form_data = attributes[:s3_form_data]
    end
    
    def serialize
      {
        id: self.id,
        website_id: self.website_id,
        release_id: self.release_id,
        md5: self.md5,
        bytes: self.bytes,
        path: self.path
      }
    end
    
    # TODO: upload to S3
    
  end
  
  class API

    def confirm_file(website_id, release_id, id)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/v1/websites/#{website_id}/releases/#{release_id}/files/#{id}/confirm"
      )
    end

  end
end