RSpec.describe 'A typical flow' do
  let(:token) { Vng::SecurityToken.create host: Vng.configuration.host, username: Vng.configuration.username, password: Vng.configuration.password }
  let(:zips) { Vng::Zip.all }
  let(:franchises) { Vng::Franchise.all }
  let(:active_franchise) { Vng::Franchise.find_by zip: '97703' }
  let(:inactive_franchise) { Vng::Franchise.find_by zip: '97403' }
  let(:breeds) { Vng::Breed.all }
  let(:lead) { Vng::Lead.create name: 'Vng Example', email: 'vng@example.com', phone: '8648648640' }
  let(:contact) { Vng::Contact.create client_id: lead.id, first_name: 'Vng', last_name: 'Example', email: 'vng@example.com', phone: '8648648640' }
  let(:location) { Vng::Location.create client_id: lead.id, address: '16 NW Kansas Ave', city: 'Bend', state: 'OR', zip: '97703' }
  let(:asset) { Vng::Asset.create name: 'Lassie', weight: 66, breed_option_id: breeds.first.option_id, client_id: lead.id }
  let(:price_items) { Vng::PriceItem.where location_id: location.id, asset_id: asset.id }
  let(:service_types) { Vng::ServiceType.all }
  let(:service_types_by_zip) { Vng::ServiceType.where zip: '97703' }
  let(:availability) { Vng::Availability.where(location_id: location.id, duration: 30, from_time: Time.now, to_time: (Time.now + 60*60*24*5)).first }
  let(:lock) { Vng::Lock.create duration: 30, location_id: location.id, date: availability.date, minutes: availability.minutes, route_id: availability.route_id }
  let(:line_items) { price_items.take(3).map do |price_item|
    { price_item_id: price_item.id, tax_id: price_item.tax_id, asset_id: asset.id, description: price_item.price_item, price: price_item.value }
  end }
  let(:work_order) { Vng::WorkOrder.create lock_id: lock.id, client_id: lead.id, contact_id: contact.id, location_id: location.id, duration: 30, summary: 'Example work order', line_items: line_items }
  let(:casus) { Vng::Case.create client_id: lead.id, summary: 'Vng case', comments: 'An example case' }

  after do
    casus.destroy
    work_order.destroy
    lock.destroy
    asset.destroy
    location.destroy
    contact.destroy
    lead.destroy
    token.destroy
  end

  it 'is successful' do
    expect(token).to be_a Vng::SecurityToken
    expect(zips).to all be_a Vng::Zip
    expect(franchises).to all be_a Vng::Franchise
    expect(active_franchise).to be_a Vng::Franchise
    expect(inactive_franchise).to be_nil
    expect(breeds).to all be_a Vng::Breed
    expect(lead).to be_a Vng::Lead
    expect(contact).to be_a Vng::Contact
    expect(location).to be_a Vng::Location
    expect(asset).to be_a Vng::Asset
    expect(price_items).to all be_a Vng::PriceItem
    expect(service_types).to all be_a Vng::ServiceType
    expect(service_types_by_zip).to all be_a Vng::ServiceType
    expect(availability).to be_a Vng::Availability
    expect(lock).to be_a Vng::Lock
    expect(work_order).to be_a Vng::WorkOrder
    expect(casus).to be_a Vng::Case
  end
end

