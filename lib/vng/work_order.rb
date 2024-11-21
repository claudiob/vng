require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo work orders.
  class WorkOrder < Resource
    PATH = '/api/v1/data/WorkOrders/'

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(lock_id:, client_id:, contact_id:, location_id:, duration:, summary:, line_items:)
      body = {
        method: '3',
        serviceTypeID: '14', # only return items of serviceType 'Pet Grooming'
        lockID: lock_id,
        clientID: client_id,
        contactID: contact_id,
        locationID: location_id,
        Fields: [
          { fieldID: 200, fieldValue: summary },
          { fieldID: 186, fieldValue: duration.to_i },
          { fieldID: 201, optionID: '9537' } # label: Online Tentative
        ],
        Charges: charges_for(line_items)
      }

      data = request path: PATH, body: body

      new id: data['WorkOrder']['objectID']
    end

    # Returns the URL to manage the work order in the Vonigo UI.
    def url
      "https://#{self.class.host}/Schedule/Job/Job_Main.aspx?woID=#{id}"
    end

  private

    def self.charges_for(line_items)
      line_items.map do |line_item|
        {
          priceItemID: line_item[:price_item_id],
          taxID: line_item[:tax_id],
          assetID: line_item[:asset_id],
          Fields: charge_fields_for(line_item)
        }
      end
    end

    def self.charge_fields_for(line_item)
      [
        { fieldID: 9289, fieldValue: line_item[:description] },
        { fieldID: 9287, fieldValue: line_item[:price] }, # Unit price
        { fieldID: 8673, fieldValue: line_item[:price] }, # Price item
        { fieldID: 813, fieldValue: line_item[:price] }, # Price
        { fieldID: 9286, fieldValue: line_item[:price] }, # Subtotal
        { fieldID: 9283, fieldValue: line_item[:price] }, # Total
        { fieldID: 9288, fieldValue: 1 }, # Qty
      ]
    end
  end
end
