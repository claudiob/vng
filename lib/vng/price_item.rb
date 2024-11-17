require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo price items.
  class PriceItem < Resource
    PATH = '/api/v1/data/priceLists/'

    attr_reader :id, :price_item, :value, :tax_id, :duration_per_unit, :service_badge, :service_category

    def initialize(id:, price_item:, value:, tax_id:, duration_per_unit:, service_badge:, service_category:)
      @id = id
      @price_item = price_item
      @value = value
      @tax_id = tax_id
      @duration_per_unit = duration_per_unit
      @service_badge = service_badge
      @service_category = service_category
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
        value = body['value']
        tax_id = body['taxID']
        duration_per_unit = body['durationPerUnit']
        service_badge = body['serviceBadge']
        service_category = body['serviceCategory']

        new id: id, price_item: price_item, value: value, tax_id: tax_id, duration_per_unit: duration_per_unit, service_badge: service_badge, service_category: service_category
      end
    end
  end
end
