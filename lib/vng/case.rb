module Vng
  # Provides methods to interact with Vonigo cases.
  class Case
    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(client_id:, summary:, comments:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: "3",
        objectID: client_id,
        Fields: [
           {fieldID: 219, optionID: 239}, # Status: open
           {fieldID: 220, fieldValue: summary},
           {fieldID: 230, fieldValue: comments},
        ]
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Cases/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      new id: JSON(response.body)["Case"]["objectID"]
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: "4",
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Cases/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end

