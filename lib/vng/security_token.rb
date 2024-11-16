require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo work security tokens.
  class SecurityToken < Resource
    PATH = '/api/v1/security/login/'

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

      data = request path: PATH, body: body, include_security_token: false

      new token: data['securityToken'], host: host
    end

    def destroy
      body = {
        securityToken: @token,
      }

      self.class.request path: PATH, body: body, include_security_token: false
    end
  end
end
