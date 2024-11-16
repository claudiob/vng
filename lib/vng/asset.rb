module Vng
  # Provides methods to interact with Vonigo assets.
  class Asset
    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(name:, weight:, breed_option_id:, client_id:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: "3",
        clientID: client_id,
        Fields: [
           {fieldID: 1013, fieldValue: name},
           {fieldID: 1017, fieldValue: weight},
           {fieldID: 1014, optionID: breed_option_id},
        ]
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Assets/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      # curl = 'curl'.tap do |curl|
      #   curl <<  " -X POST"
      #   request.each_header{|k, v| curl << %Q{ -H "#{k}: #{v}"}}
      #   curl << %Q{ -d '#{request.body}'} if request.body
      #   curl << %Q{ "#{uri.to_s}"}
      # end
      # puts curl

      new id: JSON(response.body)["Asset"]["objectID"]
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: "4",
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Assets/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end

