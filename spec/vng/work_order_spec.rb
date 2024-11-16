RSpec.describe Vng::WorkOrder do
  describe '.create' do
    let(:lead) { Vng::Lead.create name: 'Test Example', email: 'test@example.com', phone: '5553456789' }

    let(:breed) { Vng::Breed.all.first }
    let(:asset) { Vng::Asset.create name: 'Lassie', weight: 66, breed_option_id: breed.option_id, client_id: lead.id }
    let(:price_items) { Vng::PriceItem.where location_id: location.id, asset_id: asset.id }

    let(:contact) { Vng::Contact.create(client_id: lead.id, first_name: 'Test', last_name: 'Example', email: 'test@example.com', phone: '5553456789') }
    let(:location) { Vng::Location.create client_id: lead.id, address: '16 NW Kansas Ave', city: 'Bend',  state: 'OR', zip: '97703' }
    let(:availability) { Vng::Availability.where(location_id: location.id, duration: 30, from_time: Time.now, to_time: (Time.now + 60*60*24*5)).first }
    let(:lock) { Vng::Lock.create duration: 30, location_id: location.id, date: availability.date, minutes: availability.minutes, route_id: availability.route_id }
    let(:line_items) { price_items.take(3).map do |price_item|
      {
        price_item_id: price_item.id,
        tax_id: price_item.tax_id,
        asset_id: asset.id,
        description: price_item.price_item,
        price: price_item.value,
      }
    end }
    let(:work_order) { Vng::WorkOrder.create lock_id: lock.id, client_id: lead.id, contact_id: contact.id, location_id: location.id, duration: 30, summary: 'Example work order', line_items: line_items }

    after do
      work_order.destroy
      lock.destroy
      location.destroy
      contact.destroy
      asset.destroy
      lead.destroy
    end

    it "creates a work order" do
      expect(lead).to be_a(Vng::Lead)
      expect(location).to be_a(Vng::Location)
      expect(availability).to be_a(Vng::Availability)
      expect(lock).to be_a(Vng::Lock)
      expect(work_order).to be_a(Vng::WorkOrder)
    end
  end
end
