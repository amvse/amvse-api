module Amvse
  class API
    module Mock

      # stub POST /sessions
      Excon.stub(:expects => 200, :method => :post, :path => '/v1/sessions') do |params|
        request_params, mock_data = parse_stub_params(params)
        {
          :body   => {
            'token'     => SecureRandom.hex(20)
          },
          :status => 200
        }
      end

    end
  end
end