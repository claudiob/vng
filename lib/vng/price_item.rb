require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo price items.
  class PriceItem < Resource
    PATH = '/api/v1/data/priceLists/'

    attr_reader :id, :price_item, :index, :description, :value, :tax_id, :duration_per_unit, :service_badge, :service_category, :price_block_id

    def initialize(id:, price_item:, index:, description:, value:, tax_id:, duration_per_unit:, service_badge:, service_category:, price_block_id:)
      @id = id
      @price_item = price_item
      @index = index
      @description = description
      @value = value
      @tax_id = tax_id
      @duration_per_unit = duration_per_unit
      @service_badge = service_badge
      @service_category = service_category
      @price_block_id = price_block_id
    end

    def self.for_price_list_id(price_list_id)
      body = {
        method: '1',
        priceListID: price_list_id,
      }

      data = request path: '/api/v1/resources/priceItems/', body: body, returning: 'PriceItems'

      data.filter_map do |body|
        next unless body['isOnline'] && body['isActive']

        id = body['priceItemID']
        price_item = body['priceItem']
        index = body['sequence']
        description = body['descriptionHelp']
        value = body['value']
        tax_id = body['taxID']
        duration_per_unit = body['durationPerUnit']
        service_badge = body['serviceBadge']
        service_category = body['serviceCategory']
        price_block_id = body['priceBlockID']

        new id: id, price_item: price_item, index: index, description: description, value: value, tax_id: tax_id, duration_per_unit: duration_per_unit, service_badge: service_badge, service_category: service_category, price_block_id: price_block_id
      end
    end

    def self.where(location_id:, asset_id:)
      body = {
        method: '2',
        serviceTypeID: '14', # only return items of serviceType 'Pet Grooming'
        locationID: location_id,
        assetID: asset_id,
      }

      data = request path: PATH, body: body

      data['PriceItems'].filter do |body|
        body['isOnline'] && body['isActive']
      end.map do |body|
        id = body['priceItemID']
        price_item = body['priceItem']
        index = body['sequence']
        description = body['descriptionHelp']
        value = body['value']
        tax_id = body['taxID']
        duration_per_unit = body['durationPerUnit']
        service_badge = body['serviceBadge']
        service_category = body['serviceCategory']
        price_block_id = body['priceBlockID']

        new id: id, price_item: price_item, index: index, description: description, value: value, tax_id: tax_id, duration_per_unit: duration_per_unit, service_badge: service_badge, service_category: service_category, price_block_id: price_block_id
      end
    end
  end
end
