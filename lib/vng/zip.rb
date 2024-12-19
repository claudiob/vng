require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo ZIP codes.
  class Zip < Resource
    PATH = '/api/v1/resources/zips/'

    attr_reader :zip, :state, :zone_name

    def initialize(zip:, state:, zone_name:)
      @zip = zip
      @state = state
      @zone_name = zone_name
    end

    def self.all
      data = request path: PATH

      data['Zips'].map do |body|
        zip = body['zip']
        state = body['state']
        zone_name = body['zoneName']

        # TODO!! Remove the inactive ones

        new zip: zip, state: state, zone_name: zone_name
      end
    end
  end
end
