require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo cases.
  class Case < Resource
    PATH = '/api/v1/data/Cases/'

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(client_id:, summary:, comments:, phone:, email:, zip:)
      body = {
        method: '3',
        clientID: client_id,
        Fields: [
           { fieldID: 219, optionID: 239 }, # Status: open
           { fieldID: 220, fieldValue: summary }, # Summary:
           { fieldID: 230, fieldValue: comments }, # Comments:
           { fieldID: 226, optionID: 227 }, # Type: 'General request'
           { fieldID: 227, optionID: 232 }, # Preferred Contact Method: 'Phone'
           { fieldID: 228, fieldValue: phone }, # Phone Me Back at:
           { fieldID: 229, fieldValue: email }, # Email:
           { fieldID: 1023, fieldValue: zip }, # Zip Code:
        ]
      }

      data = request path: PATH, body: body

      new id: data['Case']['objectID']
    end

    def destroy
      body = {
        method: '4',
        objectID: id,
      }

      self.class.request path: PATH, body: body
    end
  end
end
