module Vng
  # Provides methods to interact with Vonigo breeds.
  class Breed
    attr_reader :id, :name, :species, :option_id, :low_weight, :high_weight

    def initialize(id:, name:, species:, option_id:, low_weight:, high_weight:)
      @id = id
      @name = name
      @species = species
      @option_id = option_id
      @low_weight = low_weight
      @high_weight = high_weight
    end

    # TODO: Needs pagination
    def self.all
      body = {
        securityToken: Vng.configuration.security_token,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/breeds/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)["Breeds"].map do |body|
        id = body["breedID"]
        name = body["breed"]
        species = body["species"]
        option_id = body["optionID"]
        low_weight = body["breedLowWeight"]
        high_weight = body["breedHighWeight"]

        new id: id, name: name, species: species, option_id: option_id, low_weight: low_weight, high_weight: high_weight
      end
    end
  end
end
