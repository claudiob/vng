RSpec.describe 'A typical flow' do
  let(:zip) { '97703' }
  let(:phone) { '8648648640' }
  let(:email) { 'vng@example.com' }

  let(:token) { Vng::SecurityToken.create }
  before { Vng.configure { |config| config.security_token = token.token } }
  let(:zips) { Vng::Zip.all }
  let(:zip_code) { Vng::Zip.find_by zip: zip }
  let(:routes) { Vng::Route.all }
  let(:franchises) { Vng::Franchise.all }
  let(:active_franchise) { Vng::Franchise.find_by zip: zip }
  let(:inactive_franchise) { Vng::Franchise.find_by zip: '97403' }
  let(:franchise) { Vng::Franchise.find active_franchise.id }
  let(:breeds) { Vng::Breed.all }
  let(:lead) { Vng::Lead.create name: 'Vng Example', email: email, phone: phone }
  let(:contact) { Vng::Contact.create client_id: lead.id, first_name: 'Vng', last_name: 'Example', email: email, phone: phone }
  let(:location) { Vng::Location.create client_id: lead.id, address: '16 NW Kansas Ave', city: 'Bend', state: 'OR', zip: zip }
  let(:asset) { Vng::Asset.create name: 'Lassie', weight: 66, breed_option_id: breeds.first.option_id, client_id: lead.id }
  let(:price_lists) { Vng::PriceList.all }
  let(:price_blocks) { Vng::PriceBlock.for_price_list_id(price_lists.first.id) }
  let(:list_price_items) { Vng::PriceItem.for_price_list_id(price_lists.first.id) }
  let(:price_items) { Vng::PriceItem.where location_id: location.id, asset_id: asset.id }
  let(:availability) { Vng::Availability.where(location_id: location.id, duration: 30, from_time: Time.now, to_time: (Time.now + 60*60*24*5)).first }
  let(:route) { Vng::Route.all.find { |route| route.id == availability.route_id } }
  let(:lock) { Vng::Lock.create duration: 30, location_id: location.id, date: availability.date, minutes: availability.minutes, route_id: route.id }
  let(:line_items) { price_items.take(3).map do |price_item|
    { price_item_id: price_item.id, tax_id: price_item.tax_id, asset_id: asset.id, description: price_item.price_item, price: price_item.value }
  end }
  let(:work_order) { Vng::WorkOrder.create lock_id: lock.id, client_id: lead.id, contact_id: contact.id, location_id: location.id, duration: 30, summary: 'Example work order', line_items: line_items }
  let(:work_orders) { Vng::WorkOrder.for_client_id lead.id }
  let(:casus) { Vng::Case.create client_id: lead.id, summary: 'Vng case', comments: 'An example case', phone: phone, email: email, zip: zip  }

  after do
    casus.destroy
    asset.destroy
    token.destroy
  end

  it 'is successful' do
    expect(token).to be_a Vng::SecurityToken
    expect(zips).to all be_a Vng::Zip
    expect(zip_code).to be_a Vng::Zip
    expect(franchises).to all be_a Vng::Franchise
    expect(active_franchise).to be_a Vng::Franchise
    # expect(inactive_franchise).to be_nil
    expect(franchise).to be_a Vng::Franchise
    expect { token.assign_to franchise_id: active_franchise.id }.not_to raise_error
    expect(breeds).to all be_a Vng::Breed
    expect(lead).to be_a Vng::Lead
    expect(contact).to be_a Vng::Contact
    expect(location).to be_a Vng::Location
    expect(asset).to be_a Vng::Asset
    expect(price_lists).to all be_a Vng::PriceList
    expect(price_blocks).to all be_a Vng::PriceBlock
    expect(list_price_items).to all be_a Vng::PriceItem
    expect(price_items).to all be_a Vng::PriceItem
    expect(availability).to be_a Vng::Availability
    expect(lock).to be_a Vng::Lock
    expect(work_order).to be_a Vng::WorkOrder
    expect(work_order.url).to match URI::regexp
    expect(work_orders).to be_all be_a Vng::WorkOrder
    expect(casus).to be_a Vng::Case
    expect(casus.url).to match URI::regexp
  end
end
