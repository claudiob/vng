module Vng
  # Provides methods to interact with Vonigo work orders.
  class WorkOrder
    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(lock_id:, client_id:, contact_id:, location_id:, duration:, summary:, line_items:)
      charges = line_items.map do |line_item|
        {
          priceItemID: line_item[:price_item_id],
          taxID: line_item[:tax_id],
          assetID: line_item[:asset_id],
          Fields: [
            {fieldID: 9289, fieldValue: line_item[:description]},
            {fieldID: 9287, fieldValue: line_item[:price]}
          ]
        }
      end

      body = {
        securityToken: Vng.configuration.security_token,
        method: "3",
        serviceTypeID: "14", # only return items of serviceType "Pet Grooming"
        lockID: lock_id,
        clientID: client_id,
        contactID: contact_id,
        locationID: location_id,
        Fields: [
          {fieldID: 200, fieldValue: summary},
          {fieldID: 186, fieldValue: duration.to_i},
          {fieldID: 201, optionID: "9537"} # label: Online Tentative
        ],
        Charges: charges
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/WorkOrders/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      id = JSON(response.body)["WorkOrder"]["objectID"]
      new id: id
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: "4",
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/WorkOrders/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end
