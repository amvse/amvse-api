module Amvse
  class API
    module Mock

      # stub GET /websites/
      Excon.stub(:expects => 200, :method => :get, :path => '/v1/websites') do |params|
        request_params, mock_data = parse_stub_params(params)
        {
          :body   => MultiJson.dump(mock_data[:websites]),
          :status => 200
        }
      end

      # stub GET /websites/:website_id
      Excon.stub(:expects => 200, :method => :get, :path => %r{^/v1/websites/([^/]+)$} ) do |params|
        request_params, mock_data = parse_stub_params(params)
        website_id, _ = request_params[:captures][:path]
        with_mock_website(mock_data, website_id) do |website_data|
          {
            :body   => MultiJson.dump(website_data),
            :status => 200
          }
        end
      end

      # stub POST /websites
      Excon.stub(:expects => 201, :method => :post, :path => '/v1/websites') do |params|
        request_params, mock_data = parse_stub_params(params)
        domain_name = request_params[:query].has_key?('website[domain_name]') && request_params[:query]['website[domain_name]'] || "generated-name-#{rand(999)}"
        id = rand(99999)
        website_data = {
          'realtime_channel_name' => "__amvse_Website_#{id}",
          'id'                    => id,
          'domain_name'           => domain_name,
          'updated_at'            => timestamp
        }
        {
          :body   => MultiJson.dump(website_data),
          :status => 201
        }
      end

      # stub PUT /websites/:website_id
      Excon.stub(:expects => 200, :method => :put, :path => %r{^/v1/websites/([^/]+)$}) do |params|
        request_params, mock_data = parse_stub_params(params)
        website_id, _ = request_params[:captures][:path]

        with_mock_website(mock_data, website_id) do |website_data|
          response_data = {
            'realtime_channel_name' => "__amvse_Website_#{website_id}",
            'id'                    => website_id,
            'updated_at'            => timestamp
          }.merge website_data
          {
            :body   => MultiJson.dump(response_data),
            :status => 200
          }
        end
      end

    end
  end
end