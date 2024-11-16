require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo assets.
  class Asset < Resource
    PATH = '/api/v1/data/Assets/'

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(name:, weight:, breed_option_id:, client_id:)
      body = {
        method: '3',
        clientID: client_id,
        Fields: [
           {fieldID: 1013, fieldValue: name},
           {fieldID: 1017, fieldValue: weight},
           {fieldID: 1014, optionID: breed_option_id},
        ]
      }

      data = request path: PATH, body: body

      # curl = 'curl'.tap do |curl|
      #   curl <<  ' -X POST'
      #   request.each_header{|k, v| curl << %Q{ -H "#{k}: #{v}"}}
      #   curl << %Q{ -d '#{request.body}'} if request.body
      #   curl << %Q{ "#{uri.to_s}"}
      # end
      # puts curl

      new id: data['Asset']['objectID']
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

