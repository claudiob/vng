require Vng.configuration.mock ? 'vng/mock_request' : 'vng/http_request'

module Vng
  # Provides an abstract class for every Vonigo resource.
  class Resource
  private

    def self.request(path:, body: {}, query: {}, include_security_token: true)
      if query.none? && include_security_token
        body = body.merge securityToken: Vng.configuration.security_token
      end

      HTTPRequest.new(host: host, path: path, query: query, body: body).run
    end

    def self.value_for_field(data, field_id)
      field = data['Fields'].find { |field| field['fieldID'] == field_id }
      field['fieldValue'] if field
    end

    # @return [String] the Vonigo API host.
    def self.host
      Vng.configuration.host
    end
  end
end
