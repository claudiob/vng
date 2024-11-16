require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo contacts.
  class Contact < Resource
    PATH = '/api/v1/data/Contacts/'

    attr_reader :id, :first_name, :last_name, :email, :phone

    def initialize(id:, first_name:, last_name:, email:, phone:)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @email = email
      @phone = phone
    end

    def self.create(first_name:, last_name:, email:, phone:, client_id:)
      body = {
        method: '3',
        clientID: client_id,
        Fields: [
           {fieldID: 127, fieldValue: first_name},
           {fieldID: 128, fieldValue: last_name},
           {fieldID: 97, fieldValue: email},
           {fieldID: 96, fieldValue: phone},
        ]
      }

      data = request path: PATH, body: body

      id = data['Contact']['objectID']
      first_name = data['Fields'].find{|field| field['fieldID'] == 127}['fieldValue']
      last_name = data['Fields'].find{|field| field['fieldID'] == 128}['fieldValue']
      email = data['Fields'].find{|field| field['fieldID'] == 97}['fieldValue']
      phone = data['Fields'].find{|field| field['fieldID'] == 96}['fieldValue']

      new id: id, first_name: first_name, last_name: last_name, email: email, phone: phone
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

