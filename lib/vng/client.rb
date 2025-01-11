require 'vng/availability'

module Vng
  # Provides methods to interact with Vonigo clients.
  class Client < Resource
    PATH = '/api/v1/data/Clients/'

    attr_reader :id, :email

    def initialize(id:, email:)
      @id = id
      @email = email
    end


    def self.find(contact_id)
      body = {
        method: '1',
        objectID: contact_id,
      }

      data = request path: PATH, body: body

      email = value_for_field data, 238
      new id: contact_id, email: email
    end
  end
end
