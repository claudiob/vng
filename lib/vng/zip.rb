module Vng
  # Provides methods to interact with Vonigo ZIP codes.
  class Zip
    attr_reader :zip, :state, :zone_name

    def initialize(zip:, state:, zone_name:)
      @zip = zip
      @state = state
      @zone_name = zone_name
    end

    # TODO: Needs pagination
    def self.all
      body = {
        securityToken: Vng.configuration.security_token,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/zips/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)['Zips'].map do |body|
        zip = body['zip']
        state = body['state']
        zone_name = body['zoneName']

        new zip: zip, state: state, zone_name: zone_name
      end
    end
  end
end
