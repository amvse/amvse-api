require 'mime/types'
module Amvse
  class File
    
    attr_accessor :id, :website_id, :release_id, :md5, :bytes, :mime_type,
                 :path, :s3_url, :s3_form_data, :file_path
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.website_id = attributes['website_id']
      self.release_id = attributes['release_id']
      self.md5 = attributes['md5']
      self.bytes = attributes['bytes']
      self.mime_type = attributes['mime_type']
      self.path = attributes['path']
      self.s3_url = attributes['s3_url']
      self.s3_form_data = attributes['s3_form_data']
    end
    
    def serialize
      {
        'id': self.id,
        'website_id': self.website_id,
        'release_id': self.release_id,
        'md5': self.md5,
        'bytes': self.bytes,
        'mime_type': self.mime_type,
        'path': self.path
      }
    end
    
    def upload!(file_path=nil)
      file_path ||= self.file_path
      filename = ::File.basename(file_path)
      content_type = ::MIME::Types.type_for(filename).first.content_type
      s3_connection = Excon.new(self.s3_url)
      boundary = (0...40).map { ('a'..'z').to_a[rand(26)] }.join
      
      body = ""
      self.s3_form_data.each do |name, value|      
        body << "--#{boundary}" << Excon::CR_NL
        body << %{Content-Disposition: form-data; name="#{name}"} << Excon::CR_NL
        body << Excon::CR_NL
        body << value
        body << Excon::CR_NL
      end
      body << "--#{boundary}" << Excon::CR_NL
      body << %{Content-Disposition: form-data; name="file"; filename="#{filename}"} << Excon::CR_NL
      body << "Content-Type: #{content_type}; charset=UTF-8" << Excon::CR_NL
      body << Excon::CR_NL
      body << IO.read(file_path, encoding: 'UTF-8')
      body << Excon::CR_NL
      body << "--#{boundary}--"
      
      headers = {
        'Content-Type' => "multipart/form-data; boundary=#{boundary}",
        'Content-Length' => body.length
      }
      if response = s3_connection.post(body: body, headers: headers)
        if response.status == 201
          self.md5 = response.headers["Etag"].chomp('"').reverse.chomp('"').reverse
          return true
        end
      end
      throw "Upload failed: #{response.inspect}"
    end
    
  end
  
  class API

    def confirm_file(website_id, release_id, id, md5)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/v1/websites/#{website_id}/releases/#{release_id}/files/#{id}/confirm",
        :body     => { md5: md5 }
      )
    end

  end
end