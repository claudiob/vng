require 'vng/resource'
require 'vng/service_type'

module Vng
  # Provides methods to interact with Vonigo ZIP codes.
  class Zip < Resource
    PATH = '/api/v1/resources/zips/'

    attr_reader :zip, :state, :zone_name, :city, :service_types

    def initialize(zip:, state:, zone_name:, city: nil, service_types: [])
      @zip = zip
      @state = state
      @zone_name = zone_name
      @city = city
      @service_types = service_types
    end

    def self.all
      data = request path: PATH

      data.fetch('Zips', []).reject do |franchise|
        # TODO: add "Owned - Not In Service"
        franchise['zipStatus'].eql? 'Owned – Deactivated'
      end.map do |body|
        zip = body['zip']
        state = body['state']
        zone_name = body['zoneName']

        new zip: zip, state: state, zone_name: zone_name
      end
    end

    def self.find_by(zip:)
      body = {
        method: '1',
        zip: zip,
      }

      data = request path: PATH, body: body
      zip_data = data['Zip']

      # TODO: Remove ServiceType class, store duration and price_list_id
      # inside Zip itself
      unless zip_data['zipCodeID'] == '0'
        service_types = data['ServiceTypes'].map do |body|
          id = body['serviceTypeID']
          type = body['serviceType']
          duration = body['duration']
          price_list_id = body['priceID']
          ServiceType.new id: id, type: type, duration: duration, price_list_id: price_list_id
        end

        new zip: zip_data['zipCode'], state: zip_data['provinceAbbr'], zone_name: zip_data['zoneName'], city: zip_data['defaultCity'], service_types: service_types
      end
    end
  end
end
