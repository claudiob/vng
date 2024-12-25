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

      data['Zips'].reject do |franchise|
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

      unless zip_data['zipCodeID'] == '0'
        service_types = data['ServiceTypes'].map do |body|
          id = body['serviceTypeID']
          type = body['serviceType']
          duration = body['duration']
          ServiceType.new id: id, type: type, duration: duration
        end

        new zip: zip_data['zipCode'], state: zip_data['provinceAbbr'], zone_name: zip_data['zoneName'], city: zip_data['defaultCity'], service_types: service_types
      end
    end
  end
end
