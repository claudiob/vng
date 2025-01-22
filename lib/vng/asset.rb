require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo assets.
  class Asset < Resource
    PATH = '/api/v1/data/Assets/'

    attr_reader :id, :name, :weight, :breed_option_id

    def initialize(id:, name: nil, weight: nil, breed_option_id: nil)
      @id = id
      @name = name
      @weight = weight
      @breed_option_id = breed_option_id
    end

    def self.create(name:, weight:, breed_option_id:, client_id:)
      body = {
        method: '3',
        clientID: client_id,
        Fields: [
          { fieldID: 1013, fieldValue: name },
          { fieldID: 1017, fieldValue: weight },
          { fieldID: 1014, optionID: breed_option_id },
        ],
      }

      data = request path: PATH, body: body

      new id: data['Asset']['objectID']
    end

    def self.for_client_id(client_id)
      body = { clientID: client_id, isCompleteObject: 'true' }

      data = request path: PATH, body: body

      data.fetch('Assets', []).map do |asset|
        next unless active?(asset)

        id = asset['objectID']
        name = asset['name']
        breed_option_id = option_for_field asset, 1014
        weight = value_for_field asset, 1017
        weight = (Integer weight unless weight.empty?)
        new id: id, name: name, weight: weight, breed_option_id: breed_option_id
      end
    end

    def destroy
      body = {
        method: '4',
        objectID: id,
      }

      data = self.class.request path: PATH, body: body
    end
  end
end
