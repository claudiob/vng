require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo price lists.
  class PriceList < Resource
    PATH = '/api/v1/resources/priceLists/'

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.find_by(service_type_id:)
      data = request path: PATH

      id = data['PriceLists'].find do |price_list|
        price_list['isActive'] && price_list['serviceTypeID'] == service_type_id
      end

      new(id: id) if id
    end
  end
end
