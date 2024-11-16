require 'vng/availability'

module Vng
  # Provides methods to interact with Vonigo franchises.
  class Franchise < Resource
    PATH = '/api/v1/resources/franchises/'

    attr_reader :id, :name, :gmt_offset

    def initialize(id:, name: nil, gmt_offset: nil)
      @id = id
      @name = name
      @gmt_offset = gmt_offset
    end


    def self.find_by(zip:)
      body = {
        method: '1',
        zip: zip,
      }

      data = request path: Vng::Availability::PATH, body: body

      franchise_id = data['Ids']['franchiseID']
      new(id: franchise_id) unless franchise_id == '0'
    end

    def self.all
      data = request path: PATH

      data['Franchises'].filter do |franchise|
        franchise['isActive']
      end.map do |franchise|
        id = franchise['franchiseID']
        name = franchise['franchiseName']
        gmt_offset = franchise['gmtOffsetFranchise']

        new id: id, name: name, gmt_offset: gmt_offset
      end
    end
  end
end
