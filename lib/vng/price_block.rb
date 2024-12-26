require 'vng/resource'
require 'vng/price_list'

module Vng
  # Provides methods to interact with Vonigo price blocks.
  class PriceBlock < Resource
    PATH = '/api/v1/resources/priceBlocks/'

    attr_reader :id, :name, :index

    def initialize(id:, name:, index:)
      @id = id
      @name = name
      @index = index
    end

    def self.for_price_list_id(price_list_id)
      body = { priceListID: price_list_id }

      data = request path: PATH, body: body, returning: 'PriceBlocks'

      data.filter_map do |body|
        next unless body['isActive']

        id = body['priceBlockID']
        name = body['priceBlock']
        index = body['sequence']

        new id: id, name: name, index: index
      end
    end
  end
end
