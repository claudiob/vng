require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo leads.
  class Lead < Resource
    PATH = '/api/v1/data/Leads/'

    attr_reader :id, :name, :email, :phone

    def initialize(id:, name:, email:, phone:)
      @id = id
      @name = name
      @email = email
      @phone = phone
    end

    def self.create(name:, email:, phone:)
      body = {
        method: '3',
        Fields: [
           { fieldID: 121, optionID: '59' },
           { fieldID: 126, fieldValue: name },
           { fieldID: 238, fieldValue: URI.encode_uri_component(email) },
           { fieldID: 1024, fieldValue: phone },
        ]
      }

      data = request path: PATH, body: body

      id = data['Client']['objectID']
      name = value_for_field data, 127
      email = value_for_field data, 238
      phone = value_for_field data, 1024

      new id: id, name: name, email: email, phone: phone
    end
  end
end
