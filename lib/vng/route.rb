require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo ZIP routes.
  class Route < Resource
    PATH = '/api/v1/resources/Routes/'

    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    # TODO: Needs pagination
    def self.all
      data = request path: PATH

      data['Routes'].filter do |route|
        route['isActive']
      end.map do |body|
        id = body['routeID']
        name = body['routeName']

        new id: id, name: name
      end
    end
  end
end
