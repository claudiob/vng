require 'vng/configuration'

puts "loaded config"

# An object-oriented Ruby client for Voonigo.
# @see http://www.rubydoc.info/gems/vng/
module Vng
  # Provides methods to read and write global configuration settings.
  #
  # A typical usage is to set the Security Token for the API calls.
  #
  # @example Set the Security Token for the API client:
  #   Vng.configure do |config|
  #     config.security_token = 'ABCDEFGHIJ1234567890'
  #   end
  #
  module Config
    # Yields the global configuration to the given block.
    #
    # @example
    #   Vng.configure do |config|
    #     config.security_token = 'ABCDEFGHIJ1234567890'
    #   end
    #
    # @yield [Vng::Models::Configuration] The global configuration.
    def configure
      yield configuration if block_given?
    end

    # Returns the global {Vng::Models::Configuration} object.
    #
    # While this method _can_ be used to read and write configuration settings,
    # it is easier to use {Vng::Config#configure} Vng.configure}.
    #
    # @example
    #     Vng.configuration.security_token = 'ABCDEFGHIJ1234567890'
    #
    # @return [Vng::Models::Configuration] The global configuration.
    def configuration
      @configuration ||= Vng::Configuration.new
    end
  end

  # @note Config is the only module auto-loaded in the Vng module,
  #       in order to have a syntax as easy as Vng.configure
  extend Config
end
