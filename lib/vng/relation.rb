module Vng
  # Provides methods to iterate through collections of Vonigo resources.
  # @private
  class Relation
    include Enumerable

    # @yield [Hash] the options to change which items to iterate through.
    def initialize(options = {}, &item_block)
      @options = {parts: ['objectID', 'isActive'], next_page: 1}
      @options.merge! options
      @item_block = item_block
    end

    # Specifies which items to fetch when hitting the data API.
    # @param [Hash<Symbol, String>] conditions The conditions for the items.
    # @return [Vng::Relation] itself.
    def where(conditions = {})
      if @options[:conditions] != conditions
        @items = []
        @options.merge! conditions: conditions
      end
      self
    end

    # Specifies which parts of the resource to fetch when hitting the data API.
    # @param [Array<Symbol>] parts The parts to fetch.
    # @return [Vng::Relation] itself.
    def select(*parts)
      if @options[:parts] != parts + ['objectID', 'isActive']
        @items = nil
        @options.merge! parts: (parts + ['objectID', 'isActive'])
      end
      self
    end

    def each
      @last_index = 0
      while next_item = find_next
        yield next_item
      end
    end

  private

    def request(path:, body: {}, query: {}, include_security_token: true)
      if query.none? && include_security_token
        body = body.merge securityToken: Vng.configuration.security_token
      end

      response_for path:, body:, query:
    end

    def response_for(path:, body: {}, query: {})
      instrument do |data|
        Request.new(host: Vng.configuration.host, path: path, query: query, body: body).run
      end
    end

    def find_next
      @items ||= []
      if @items[@last_index].nil? && more_pages?
        body = @options[:conditions].merge pageSize: 500, pageNo: @options[:next_page], sortMode: 3, sortDirection: 0

        response_body = request path: '/api/v1/data/Contacts/', body: body

        more_items = response_body['Contacts'].map do |contact_data|
          Vng::Contact.new contact_data.slice(*@options[:parts])
        end
        @options.merge! next_page: (more_items.size == 500 ? @options[:next_page] + 1 : 1)
        @items.concat more_items
      end
      @items[(@last_index +=1) -1]
    end

    def more_pages?
      @last_index.zero? || @options[:next_page] > 1
    end

    # Provides instrumentation to ActiveSupport listeners
    def instrument(&block)
      data = { class_name: 'Vng::Contact' }
      if defined?(ActiveSupport::Notifications)
        ActiveSupport::Notifications.instrument 'Vng.request', data, &block
      else
        block.call data
      end
    end
  end
end
