module Amvse
  class API

    def post_session(username, password)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => '/v1/sessions',
        :body     => { 'username' => username, 'password' => password }
      ).body
    end

  end
end