module Vng
  # Provides methods to interact with Vonigo franchises.
  class Franchise
    attr_reader :id, :name, :gmt_offset

    def initialize(id:, name: nil, gmt_offset: nil)
      @id = id
      @name = name
      @gmt_offset = gmt_offset
    end


    def self.find_by(zip:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: "1",
        zip: zip,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/availability/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      franchise_id = JSON(response.body)["Ids"]["franchiseID"]
      new(id: franchise_id) unless franchise_id == "0"
    end

    def self.all
      body = {
        securityToken: Vng.configuration.security_token,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/franchises/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)["Franchises"].filter do |body|
        body["isActive"]
      end.map do |body|
        id = body["franchiseID"]
        name = body["franchiseName"]
        gmt_offset = body["gmtOffsetFranchise"]

        new id: id, name: name, gmt_offset: gmt_offset
      end
    end
  end
end
