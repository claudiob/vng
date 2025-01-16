require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo leads.
  class Lead < Resource
    PATH = '/api/v1/data/Leads/'

    attr_reader :id, :name, :email, :phone, :notes

    def initialize(id:, name:, email:, phone:, notes:)
      @id = id
      @name = name
      @email = email
      @phone = phone
      @notes = notes
    end

    def self.create(name:, email:, phone:, notes: nil, campaign_option_id: nil)
      body = {
        method: '3',
        Fields: [
           { fieldID: 121, optionID: '59' },
           { fieldID: 126, fieldValue: name },
           { fieldID: 238, fieldValue: URI.encode_uri_component(email) },
           { fieldID: 1024, fieldValue: phone },
        ]
      }

      body[:Fields] << { fieldID: 108, fieldValue: notes } if notes
      body[:Fields] << { fieldID: 795, optionID: campaign_option_id } if campaign_option_id

      data = request path: PATH, body: body

      id = data['Client']['objectID']
      name = value_for_field data, 127
      email = value_for_field data, 238
      phone = value_for_field data, 1024
      notes = value_for_field data, 108

      new id: id, name: name, email: email, phone: phone, notes: notes
    end
  end
end
