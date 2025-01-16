module Vng
  # Provides methods to interact with Vonigo system fields’ options.
  class SystemOption
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def self.for_system_field_id(system_field_id, options = {})
      options.lazy.filter_map do |option|
        next unless option['isActive']

        if option['fieldID'].eql? system_field_id
          new id: option['optionID'], name: option['name']
        end
      end # TODO: make this thing respond to find_by(name:)
    end
  end
end
