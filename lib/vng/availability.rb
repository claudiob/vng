require 'date'
require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo availabilities.
  class Availability < Resource
    PATH = '/api/v1/resources/availability/'

    attr_reader :route_id, :date, :minutes

    def initialize(route_id:, date:, minutes:)
      @route_id = route_id
      @date = date
      @minutes = minutes
    end

    def self.where(location_id:, duration:, from_time:, to_time:)
      body = {
        method: '0',
        serviceTypeID: '14', # only return items of serviceType 'Pet Grooming'
        locationID: location_id,
        duration: [duration.to_i, 30].max, # or 'duration is not provided'
        dateStart: from_time.to_i,
        dateEnd: to_time.to_i,
      }

      data = request path: PATH, body: body

      data['Availability'].map do |availability|
        route_id = availability['routeID'].to_i
        date = Date.strptime availability['dayID'], '%Y%m%d'
        minutes = availability['startTime'].to_i

        new route_id: route_id, date: date, minutes: minutes
      end
    end
  end
end
