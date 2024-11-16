module Vng
  # Provides methods to interact with Vonigo locks.
  class Lock
    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(duration:, location_id:, date:, minutes:, route_id:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: '2',
        serviceTypeID: '14', # only create items of serviceType 'Pet Grooming'
        duration: duration.to_i,
        locationID: location_id,
        dayID: date.strftime('%Y%m%d'),
        routeID: route_id,
        startTime: minutes,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/availability/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      id = JSON(response.body)['Ids']['lockID']
      new id: id
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: '4',
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/availability/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end
