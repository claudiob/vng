require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo service types.
  class ServiceType < Resource
    PATH = '/api/v1/resources/serviceTypes/'

    attr_reader :id, :type, :duration

    def initialize(id:, type:, duration:)
      @id = id
      @type = type
      @duration = duration
    end

    # TODO: Needs pagination
    def self.all
      data = request path: PATH

      data['ServiceTypes'].map do |body|
        id = body['serviceTypeID']
        type = body['serviceType']
        duration = body['duration']

        new id: id, type: type, duration: duration
      end
    end

    def self.where(zip:)
      body = {
        zip: zip,
      }

      data = request path: PATH, body: body

      data.fetch('ServiceTypes', []).filter do |body|
        body['isActive']
      end.map do |body|
        id = body['serviceTypeID']
        type = body['serviceType']
        duration = body['duration']

        new id: id, type: type, duration: duration
      end
    end
  end
end
