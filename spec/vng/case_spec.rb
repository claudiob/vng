RSpec.describe Vng::Case do
  describe '.create' do
    let(:lead) { Vng::Lead.create(name: 'Test Example', email: 'test@example.com', phone: '5553456789') }
    let(:casus) { Vng::Case.create client_id: lead.id, summary: 'Work Order created', comments: 'Example case' }

    after do
      casus.destroy
    end

    it "creates a case" do
      expect(casus).to be_a(Vng::Case)
    end
  end
end
