require 'vng/connection_error'
require 'vng/error'

module Vng
  # Provides an abstract class for every Vonigo resource.
  class Resource
  private
    def self.request(path:, body: {}, query: {}, include_security_token: true)
      uri = URI::HTTPS.build host: host, path: path
      uri.query = URI.encode_www_form(query) if query.any?

      method = query.any? ? Net::HTTP::Get : Net::HTTP::Post
      request = method.new uri.request_uri
      request.initialize_http_header 'Content-Type' => 'application/json'

      if query.none?
        body = body.merge(securityToken: security_token) if include_security_token
        request.body = body.to_json
      end

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body).tap do |data|
        raise Vng::Error, "#{data['errMsg']} #{data['Errors']}" unless data['errNo'].zero?
      end
    rescue Errno::ECONNREFUSED, SocketError => e
      raise Vng::ConnectionError, e.message
    end

    def self.host
      Vng.configuration.host
    end

    def self.security_token
      Vng.configuration.security_token
    end
  end
end
