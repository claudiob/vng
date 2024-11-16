module Vng
  # Provides methods to interact with Vonigo service types.
  class ServiceType
    attr_reader :id, :type, :duration

    def initialize(id:, type:, duration:)
      @id = id
      @type = type
      @duration = duration
    end

    # TODO: Needs pagination
    def self.all
      body = {
        securityToken: Vng.configuration.security_token,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/serviceTypes/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)["ServiceTypes"].map do |body|
        id = body["serviceTypeID"]
        type = body["serviceType"]
        duration = body["duration"]

        new id: id, type: type, duration: duration
      end
    end

    def self.where(zip:)
      body = {
        securityToken: Vng.configuration.security_token,
        zip: zip,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/serviceTypes/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)["ServiceTypes"].filter do |body|
        body["isActive"]
      end.map do |body|
        id = body["serviceTypeID"]
        type = body["serviceType"]
        duration = body["duration"]

        new id: id, type: type, duration: duration
      end
    end
  end
end
