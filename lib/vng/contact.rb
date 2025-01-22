require 'vng/resource'

require ENV['VNG_MOCK'] ? 'vng/mock_request' : 'vng/http_request'
require 'vng/relation'

module Vng
  # Provides methods to interact with Vonigo contacts.
  class Contact < Resource
    PATH = '/api/v1/data/Contacts/'

    # @param [Hash<Symbol, String>] data the options to initialize a resource.
    # @option data [String] :object_id The unique ID of a Vonigo resource.
    # @option data [Array] :fields The fields of a Vonigo resource.
    def initialize(data = {})
      @data = data
    end

    # @return [String] the resource’s unique ID.
    def id
      @data['objectID']
    end

    def active?
      self.class.active? @data
    end

    def first_name
      self.class.value_for_field @data, 127
    end

    def last_name
      self.class.value_for_field @data, 128
    end

    def email
      self.class.value_for_field @data, 97
    end

    def phone
      self.class.value_for_field @data, 96
    end

    def client_id
      self.class.value_for_relation @data, 'client'
    end

    def edited_at
      Time.at Integer(@data['dateLastEdited']), in: 'UTC'
    end

    # @return [Vng::Relation] the resources matching the conditions.
    def self.where(conditions = {})
      @where ||= Relation.new
      @where.where conditions
    end

    def self.edited_since(timestamp)
      contacts = where isCompleteObject: 'true', dateStart: timestamp.to_i, dateMode: 2
      # TODO: select should accept sub-hash, e.g.
      # .select :date_last_edited, fields: [134, 1036], relations: ['client']
      contacts = contacts.select 'dateLastEdited', 'Fields', 'Relations'
      contacts.lazy.filter(&:active?)
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
      new data['Contact']
    end
  end
end
