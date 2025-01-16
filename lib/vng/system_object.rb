require 'vng/system_field'

module Vng
  # Provides methods to interact with Vonigo system objects.
  class SystemObject < Resource
    PATH = '/api/v1/system/objects/'

    attr_reader :id, :name, :fields

    def initialize(id:, name:, fields:)
      @id = id
      @name = name
      @fields = fields
    end

    def self.find_by(name:)
      data = request path: PATH
      object = data['Objects'].find{|object| object['name'].eql? name}

      if object
        fields = SystemField.for_system_object_id object['objectTypeID']
        new id: object['objectTypeID'], name: name, fields: fields
      end
    end
  end
end
