module Vng
  # Provides methods to interact with Vonigo price items.
  class PriceItem
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
        securityToken: Vng.configuration.security_token,
        method: '2',
        serviceTypeID: '14', # only return items of serviceType 'Pet Grooming'
        locationID: location_id,
        assetID: asset_id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/priceLists/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body)['PriceItems'].filter do |body|
        # TODO: body['serviceBadge'] != 'Not Offered'
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
