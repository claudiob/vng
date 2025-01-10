require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo contacts.
  class Contact < Resource
    PATH = '/api/v1/data/Contacts/'

    attr_reader :id, :first_name, :last_name, :email, :phone, :client_id

    def initialize(id:, first_name:, last_name:, email:, phone:, client_id:)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @email = email
      @phone = phone
      @client_id = client_id
    end

    def self.all # TODO: add (edited_after: param)
      body = { isCompleteObject: 'true' }

      data = request path: PATH, body: body, returning: 'Contacts'

      data.filter_map do |body|
        next unless body['isActive']

        id = body['objectID']
        first_name = value_for_field body, 127
        last_name = value_for_field body, 128
        email = value_for_field body, 97
        phone = value_for_field body, 96
        client_id = value_for_relation body, 'client'

        new id: id, first_name: first_name, last_name: last_name, email: email, phone: phone, client_id: client_id
      end
    end

    def self.create(first_name:, last_name:, email:, phone:, client_id:)
      body = {
        method: '3',
        clientID: client_id,
        Fields: [
           { fieldID: 127, fieldValue: first_name },
           { fieldID: 128, fieldValue: last_name },
           { fieldID: 97, fieldValue: URI.encode_uri_component(email) },
           { fieldID: 96, fieldValue: phone },
        ]
      }

      data = request path: PATH, body: body

      id = data['Contact']['objectID']
      first_name = value_for_field data, 127
      last_name = value_for_field data, 128
      email = value_for_field data, 97
      phone = value_for_field data, 96

      new id: id, first_name: first_name, last_name: last_name, email: email, phone: phone, client_id: client_id
    end
  end
end
