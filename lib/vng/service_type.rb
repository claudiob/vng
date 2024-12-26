require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo service types.
  class ServiceType < Resource
    PATH = '/api/v1/resources/serviceTypes/'

    attr_reader :id, :type, :duration, :price_list_id

    def initialize(id:, type:, duration:, price_list_id:)
      @id = id
      @type = type
      @duration = duration
      @price_list_id = price_list_id
    end
  end
end
