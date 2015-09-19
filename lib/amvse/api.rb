require "base64"
require "cgi"
require "excon"
require "multi_json"
require "securerandom"
require "uri"
require "zlib"

__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), ".."))
unless $LOAD_PATH.include?(__LIB_DIR__)
  $LOAD_PATH.unshift(__LIB_DIR__)
end

require "amvse/api/errors"
require "amvse/api/mock"
require "amvse/api/version"

require "amvse/api/files"
require "amvse/api/releases"
require "amvse/api/sessions"
require "amvse/api/websites"

srand

module Amvse
  class API

    HEADERS = {
      'Accept'                => 'application/json',
      'Content-Type'          => 'application/json',
      'Accept-Encoding'       => 'gzip',
      #'Accept-Language'       => 'en-US, en;q=0.8',
      'User-Agent'            => "amvse-api/#{Amvse::API::VERSION}",
      'X-Ruby-Version'        => RUBY_VERSION,
      'X-Ruby-Platform'       => RUBY_PLATFORM
    }

    OPTIONS = {
      :headers  => {},
      :host     => 'api.amvse.dev',
      :nonblock => false,
      :scheme   => 'http'
    }

    def initialize(options={})
      options = OPTIONS.merge(options)

      @api_token = options.delete(:api_token) || ENV['AMVSE_API_KEY']
      if !@api_token && options.has_key?(:username) && options.has_key?(:password)
        username = options.delete(:username)
        password = options.delete(:password)
        @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options.merge(:headers => HEADERS))
        @api_token = self.post_session(username, password)["token"]
      end

      user_pass = ":#{@api_token}"
      options[:headers] = HEADERS.merge({
        'Authorization' => "Basic #{Base64.encode64(user_pass).gsub("\n", '')}",
      }).merge(options[:headers])

      @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options)
    end

    def api_token
      @api_token
    end

    def request(params, &block)
      begin
        if body = params[:body] and body.is_a? Hash
          params[:body] = MultiJson.dump(body)
        end
        response = @connection.request(params, &block)
      rescue Excon::Errors::HTTPStatusError => error
        klass = case error.response.status
          when 401 then Amvse::API::Errors::Unauthorized
          when 402 then Amvse::API::Errors::VerificationRequired
          when 403 then Amvse::API::Errors::Forbidden
          when 404 then Amvse::API::Errors::NotFound
          when 408 then Amvse::API::Errors::Timeout
          when 422 then Amvse::API::Errors::RequestFailed
          when 423 then Amvse::API::Errors::Locked
          when 429 then Amvse::API::Errors::RateLimitExceeded
          when /50./ then Amvse::API::Errors::RequestFailed
          else Amvse::API::Errors::ErrorWithResponse
        end

        decompress_response!(error.response)
        reerror = klass.new(error.message, error.response)
        reerror.set_backtrace(error.backtrace)
        raise(reerror)
      end

      if response.body && !response.body.empty?
        decompress_response!(response)
        begin
          response.body = MultiJson.load(response.body)
        rescue
          # leave non-JSON body as is
        end
      end

      # reset (non-persistent) connection
      @connection.reset

      response
    end

    private

    def decompress_response!(response)
      return unless response.headers['Content-Encoding'] == 'gzip'
      response.body = Zlib::GzipReader.new(StringIO.new(response.body)).read
    end

    def escape(string)
      CGI.escape(string).gsub('.', '%2E')
    end

  end
end