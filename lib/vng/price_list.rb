require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo price lists.
  class PriceList < Resource
    PATH = '/api/v1/resources/priceLists/'

    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def self.all
      data = request path: PATH

      data['PriceLists'].filter_map do |price_list|
        next unless price_list['isActive']
        next unless price_list['serviceTypeID'].eql?(14)

        id = price_list['priceListID']
        name = price_list['priceList']

        new id: id, name: name
      end
    end
  end
end
