require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo work security tokens.
  class SecurityToken < Resource
    PATH = '/api/v1/security/login/'

    attr_reader :token

    def initialize(token:)
      @token = token
    end

    def self.create
      body = {
        app_version: '1',
        company: 'Vonigo',
        username: Vng.configuration.username,
        password: Digest::MD5.hexdigest(Vng.configuration.password),
      }

      data = request path: PATH, body: body, include_security_token: false

      new token: data['securityToken']
    end

    # TODO: re-add test
    def assign_to(franchise_id:)
      body = {
        securityToken: @token,
        method: "2",
        franchiseID: franchise_id,
      }

      self.class.request path: PATH, body: body, include_security_token: false
    end

    def destroy
      body = {
        securityToken: @token,
      }

      self.class.request path: PATH, body: body, include_security_token: false
    end
  end
end
