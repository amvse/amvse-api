require 'amvse/api/mock/sessions'
require 'amvse/api/mock/websites'

module Amvse
  class API
    module Mock

      APP_NOT_FOUND  = { :body => 'App not found.',   :status => 404 }
      USER_NOT_FOUND = { :body => 'User not found.',  :status => 404 }

      @mock_data = Hash.new do |hash, key|
        hash[key] = {
          :websites         => []
        }
      end

      def self.get_mock_website(mock_data, website_id)
        mock_data[:websites].detect {|website_data| website_data['id'] == website_id}
      end

      def self.parse_stub_params(params)
        mock_data = nil

        if params[:headers].has_key?('Authorization')
          api_key = Base64.decode64(params[:headers]['Authorization']).split(':').last

          parsed = params.dup
          begin # try to JSON decode
            parsed[:body] &&= MultiJson.load(parsed[:body])
          rescue # else leave as is
          end
          mock_data = @mock_data[api_key]
        end

        [parsed, mock_data]
      end

      def self.unescape(string)
        CGI.unescape(string)
      end

      def self.timestamp
        Time.now.strftime("%G/%m/%d %H:%M:%S %z")
      end

    end
  end
end