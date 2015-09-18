module Amvse
  class API

    # GET /websites
    def get_websites
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/websites"
      ).body
    end

    # POST /websites
    def post_websites(params={})
      request(
        :expects  => 201,
        :method   => :post,
        :path     => '/v1/websites',
        :body     => website_params(params)
      ).body
    end

    # PUT /websites/:website_id
    def put_website(website_id, params)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/v1/websites/#{website_id}",
        :body     => website_params(params)
      ).body
    end

  end
end