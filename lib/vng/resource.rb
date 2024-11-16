module Vng
  # Provides an abstract class for every Vonigo resource.
  class Resource
  private
    def self.request(path:, body: {}, include_security_token: true)
      uri = URI::HTTPS.build host: host, path: path

      request = Net::HTTP::Post.new uri.request_uri
      request.initialize_http_header 'Content-Type' => 'application/json'
      body = body.merge(securityToken: security_token) if include_security_token
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON response.body
    end

    def self.host
      Vng.configuration.host
    end

    def self.security_token
      Vng.configuration.security_token
    end
  end
end
