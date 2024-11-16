module Vng
  # Provides methods to interact with Vonigo work security tokens.
  class SecurityToken
    attr_reader :token

    def initialize(token:, host:)
      @token = token
      @host = host
    end

    def self.create(host:, username:, password:)
      body = {
        app_version: '1',
        company: 'Vonigo',
        host: host,
        password: Digest::MD5.hexdigest(password),
        username: username,
      }

      uri = URI::HTTPS.build host: host, path: '/api/v1/security/login/'

      request = Net::HTTP::Get.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json; charset=utf-8'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      token = JSON(response.body)['securityToken']

      new token: token, host: host
    end

    def destroy
      body = {
        securityToken: @token,
      }

      uri = URI::HTTPS.build host: @host, path: '/api/v1/security/login/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end
