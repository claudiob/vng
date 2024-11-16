module Vng
  # Provides an object to store global configuration settings.
  #
  # This class is typically not used directly, but by calling
  # {Vng::Config#configure Vng.configure}, which creates and updates a single
  # instance of {Vng::Models::Configuration}.
  #
  # @example Set the Security Token for the API client:
  #   Vng.configure do |config|
  #     config.security_token = 'ABCDEFGHIJ1234567890'
  #   end
  #
  # @see Vng::Config for more examples.
  #
  # An alternative way to set global configuration settings is by storing
  # them in the following environment variables:
  #
  # * +VNG_HOST+ to store the host for the Vonigo API
  # * +VNG_USERNAME+ to store the username for the Vonigo API
  # * +VNG_PASSWORD+ to store the password for the Vonigo API
  #
  # In case both methods are used together,
  # {Vng::Config#configure Vng.configure} takes precedence.
  #
  # @example Set the API credentials
  #   ENV['VNG_HOST'] = 'subdomain.vonigo.com'
  #   ENV['VNG_USERNAME'] = 'VonigoUser'
  #   ENV['VNG_Password'] = 'VonigoPassword'
  #
  class Configuration
    # @return [String] the Security Token for the API calls.
    attr_accessor :security_token

    # @return [String] the URI host for the API calls.
    attr_accessor :host

    # @return [String] the username for the API calls.
    attr_accessor :username

    # @return [String] the password for the API calls.
    attr_accessor :password

    # Initialize the global configuration settings, using the values of
    # the specified following environment variables by default.
    def initialize
      @host = ENV['VNG_HOST']
      @username = ENV['VNG_USERNAME']
      @password = ENV['VNG_PASSWORD']
    end
  end
end