RSpec.describe 'A typical flow' do
  let(:zip) { '97703' }
  let(:phone) { '8648648640' }
  let(:email) { 'vng@example.com' }

  let(:lead) { Vng::Lead.create name: 'Vng Example', email: email, phone: phone }
  let(:contact) { Vng::Contact.create client_id: lead.id, first_name: 'Vng', last_name: 'Example', email: email, phone: phone }

  after do
    contact.destroy
  end

  it 'is successful' do
    expect(lead).to be_a Vng::Lead
    expect(contact).to be_a Vng::Contact
  end
end

