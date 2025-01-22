require 'vng/availability'

module Vng
  # Provides methods to interact with Vonigo franchises.
  class Franchise < Resource
    PATH = '/api/v1/resources/franchises/'

    attr_reader :id, :name, :gmt_offset, :email, :phone, :cell

    def initialize(id:, name: nil, gmt_offset: nil, email: nil, phone: nil, cell: nil)
      @id = id
      @name = name
      @gmt_offset = gmt_offset
      @email = email
      @phone = phone
      @cell = cell
    end


    def self.find_by(zip:)
      body = {
        method: '1',
        zip: zip,
      }

      data = request path: Availability::PATH, body: body

      franchise_id = data['Ids']['franchiseID']
      new(id: franchise_id) unless franchise_id == '0'
    end

    def self.find(franchise_id)
      body = {
        method: '1',
        objectID: franchise_id,
      }

      data = request path: PATH, body: body

      email = value_for_field data, 9
      phone = value_for_field data, 18
      cell = value_for_field data, 1001
      new id: franchise_id, email: email, phone: phone, cell: cell
    end

    def self.all
      data = request path: PATH

      data.fetch('Franchises', []).filter_map do |franchise|
        next unless active?(franchise)

        id = franchise['franchiseID']
        name = franchise['franchiseName']
        gmt_offset = franchise['gmtOffsetFranchise']

        new id: id, name: name, gmt_offset: gmt_offset
      end
    end
  end
end
