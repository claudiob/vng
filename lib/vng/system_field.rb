require 'vng/system_option'

module Vng
  # Provides methods to interact with Vonigo system fields.
  class SystemField < Resource
    PATH = '/api/v1/system/objects/'

    attr_reader :id, :name, :options

    def initialize(id:, name:, options:)
      @id = id
      @name = name
      @options = options
    end

    def self.for_system_object_id(system_object_id)
      body = { objectID: system_object_id, method: '1' }
      data = request path: PATH, body: body

      data['Fields'].lazy.map do |field|
        options = SystemOption.for_system_field_id field['fieldID'], data['Options']
        new id: field['fieldID'], name: field['field'], options: options
      end # TODO: make this thing respond to find_by(name:)
    end
  end
end
