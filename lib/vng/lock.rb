require 'vng/availability'

module Vng
  # Provides methods to interact with Vonigo locks.
  class Lock < Resource
    PATH = '/api/v1/resources/availability/'

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(duration:, location_id:, date:, minutes:, route_id:)
      body = {
        method: '2',
        serviceTypeID: '14', # only create items of serviceType 'Pet Grooming'
        duration: duration.to_i,
        locationID: location_id,
        dayID: date.strftime('%Y%m%d'),
        routeID: route_id,
        startTime: minutes,
      }

      data = request path: Vng::Availability::PATH, body: body

      new id: data['Ids']['lockID']
    end

    def destroy
      body = {
        method: '4',
        objectID: id,
      }

      self.class.request path: PATH, body: body
    end
  end
end
