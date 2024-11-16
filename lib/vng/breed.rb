require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo breeds.
  class Breed < Resource
    PATH = '/api/v1/resources/breeds/'

    attr_reader :id, :name, :species, :option_id, :low_weight, :high_weight

    def initialize(id:, name:, species:, option_id:, low_weight:, high_weight:)
      @id = id
      @name = name
      @species = species
      @option_id = option_id
      @low_weight = low_weight
      @high_weight = high_weight
    end

    # TODO: Needs pagination
    def self.all
      data = request path: PATH

      data['Breeds'].map do |breed|
        id = breed['breedID']
        name = breed['breed']
        species = breed['species']
        option_id = breed['optionID']
        low_weight = breed['breedLowWeight']
        high_weight = breed['breedHighWeight']

        new id: id, name: name, species: species, option_id: option_id, low_weight: low_weight, high_weight: high_weight
      end
    end
  end
end
