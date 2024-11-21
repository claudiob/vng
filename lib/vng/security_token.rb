require 'digest/md5'
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

    def assign_to(franchise_id:)
      body = {
        securityToken: @token,
        method: "2",
        franchiseID: franchise_id,
      }

      self.class.request path: '/api/v1/security/session/', body: body, include_security_token: false
    rescue Error => e
      raise unless e.message.include? 'Same franchise ID supplied'
    end

    def destroy
      query = { securityToken: @token }
      self.class.request path: '/api/v1/security/logout/', query: query
    rescue Error => e
      raise unless e.message.include?('Session expired') || e.message.include?('Session does not exist')
    end
  end
end
