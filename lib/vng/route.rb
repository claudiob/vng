require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo ZIP routes.
  class Route < Resource
    PATH = '/api/v1/resources/Routes/'

    attr_reader :id, :name, :type_id

    def initialize(id:, name:, type_id:)
      @id = id
      @name = name
      @type_id = type_id
    end

    def self.all
      data = request path: PATH

      data.fetch('Routes', []).filter do |route|
        route['isActive']
      end.map do |body|
        id = body['routeID']
        name = body['routeName']
        type_id = body['routeTypeID']

        new id: id, name: name, type_id: type_id
      end
    end
  end
end
