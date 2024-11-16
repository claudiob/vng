module Vng
  # Provides methods to interact with Vonigo availabilities.
  class Availability
    attr_reader :route_id, :date, :minutes

    def initialize(route_id:, date:, minutes:)
      @route_id = route_id
      @date = date
      @minutes = minutes
    end

    def self.where(location_id:, duration:, from_time:, to_time:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: '0',
        serviceTypeID: '14', # only return items of serviceType 'Pet Grooming'
        locationID: location_id,
        duration: duration.to_i,
        dateStart: from_time.to_i,
        dateEnd: to_time.to_i,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/resources/availability/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)['Availability'].map do |body|
        route_id = body['routeID']
        date = Date.strptime body['dayID'], '%Y%m%d'
        minutes = body['startTime'].to_i

        new route_id: route_id, date: date, minutes: minutes
      end
    end
  end
end
