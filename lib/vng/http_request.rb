require 'json'
require 'net/http'

require 'vng/connection_error'
require 'vng/error'

module Vng
  # A wrapper around +Net::HTTP+ to send HTTP requests to the Vonigo API and
  # return their result or raise an error if the result is unexpected.
  # The basic way to use HTTPRequest is by calling +run+ on an instance.
  # @example List the species of all breeds.
  #   host = ''subdomain.vonigo.com'
  #   path = '/api/v1/resources/breeds/'
  #   body = {securityToken: security_token}
  #   response = Vng::HTTPRequest.new(path: path, body: body).run
  #   response['Breeds'].map{|breed| breed['species']}
  # @api private
  class HTTPRequest
    # Initializes an HTTPRequest object.
    # @param [Hash] options the options for the request.
    # @option options [String] :host The host of the request URI.
    # @option options [String] :path The path of the request URI.
    # @option options [Hash] :query ({}) The params to use as the query
    #   component of the request URI, for instance the Hash +{a: 1, b: 2}+
    #   corresponds to the query parameters +"a=1&b=2"+.
    # @option options [Hash] :body The body of the request.
    def initialize(options = {})
      @host = options[:host]
      @path = options[:path]
      @body = options[:body]
      @query = options.fetch :query, {}
    end

    # Sends the request and returns the body parsed from the JSON response.
    # @return [Hash] the body parsed from the JSON response.
    # @raise [Vng::ConnectionError] if the request fails.
    # @raise [Vng::Error] if parsed body includes errors.
    def run
      JSON(response.body).tap do |data|
        raise Error, "#{data['errMsg']} #{data['Errors']}" unless data['errNo'].zero?
      end
    end

  private

    # Run the request and memoize the response or the server error received.
    def response
      instrument do |data|
        @response ||= Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request http_request
        end
        data[:response] = @response
      end
    rescue *server_errors => e
      raise ConnectionError, e.message
    end

    # @return [URI::HTTPS] the (memoized) URI of the request.
    def uri
      attributes = { host: @host, path: @path, query: URI.encode_www_form(@query) }
      @uri ||= URI::HTTPS.build attributes
    end

    # @return [Net::HTTPRequest] the full HTTP request object,
    #   inclusive of headers of request body.
    def http_request
      http_class = @query.any? ? Net::HTTP::Get : Net::HTTP::Post

      @http_request ||= http_class.new(uri.request_uri).tap do |request|
        set_request_body! request
        set_request_headers! request
      end
    end

    # Adds the request headers to the request in the appropriate format.
    # The User-Agent header is also set to recognize the request.
    def set_request_headers!(request)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.add_field 'User-Agent', 'Vng::HTTPRequest'
    end

    # Adds the request body to the request in the appropriate format.
    def set_request_body!(request)
      request.body = @body.to_json if @body
    end

    # Returns the list of server errors worth retrying the request once.
    def server_errors
      [
        Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ENETUNREACH,
        Errno::ETIMEDOUT, Errno::ECONNREFUSED, Net::HTTPServerError,
        OpenSSL::SSL::SSLError, OpenSSL::SSL::SSLErrorWaitReadable,
        Net::OpenTimeout, SocketError,
      ]
    end

    # Provides instrumentation to ActiveSupport listeners
    def instrument(&block)
      data = {
        request: http_request,
        method: http_request.method,
        request_uri: uri
      }
      if defined?(ActiveSupport::Notifications)
        ActiveSupport::Notifications.instrument 'Vng.request', data, &block
      else
        block.call(data)
      end
    end
  end
end
