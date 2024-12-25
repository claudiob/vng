require ENV['VNG_MOCK'] ? 'vng/mock_request' : 'vng/http_request'

module Vng
  # Provides an abstract class for every Vonigo resource.
  class Resource
  private

    def self.request(path:, body: {}, query: {}, include_security_token: true, returning: nil)
      if query.none? && include_security_token
        body = body.merge securityToken: Vng.configuration.security_token
      end

      if returning
        [].tap do |response|
          1.step do |page_number|
            body = body.merge pageSize: 500, pageNo: page_number
            batch = response_for(path:, body:, query:).fetch(returning, [])
            break if batch.empty? || page_number > 20
            response.concat batch
          end
        end
      else
        response_for path:, body:, query:
      end
    end

    def self.response_for(path:, body: {}, query: {})
      instrument do |data|
        Request.new(host: host, path: path, query: query, body: body).run
      end
    end

    def self.value_for_field(data, field_id)
      field = data['Fields'].find { |field| field['fieldID'] == field_id }
      field['fieldValue'] if field
    end

    # @return [String] the Vonigo API host.
    def self.host
      Vng.configuration.host
    end

    # Provides instrumentation to ActiveSupport listeners
    def self.instrument(&block)
      data = { class_name: name }
      if defined?(ActiveSupport::Notifications)
        ActiveSupport::Notifications.instrument 'Vng.request', data, &block
      else
        block.call data
      end
    end
  end
end
