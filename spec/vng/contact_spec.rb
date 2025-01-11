RSpec.describe Vng::Contact do

  let(:token) { Vng::SecurityToken.create }
  before { Vng.configure { |config| config.security_token = token.token } }

  context '.edited_after(timestamp)' do
    subject(:contacts) { Vng::Contact.edited_since(Time.now - 3600) }

    it 'returns the contacts last edited after the timestamp' do
      expect(contacts.map &:first_name).to all be_a String
      expect(contacts.map &:last_name).to all be_a String
      expect(contacts.map(&:email).compact).to all be_a String
      expect(contacts.map &:phone).to all be_a String
      expect(contacts.map &:client_id).to all be_an Integer
      expect(contacts.map &:edited_at).to all be_a Time
    end
  end

  context 'with ActiveSupport::Notifications' do
    before { module ActiveSupport; class Notifications; def self.instrument(name, payload); yield; end; end; end }
    after { ActiveSupport.send :remove_const, :Notifications }
    subject(:contacts) { Vng::Contact.edited_since(Time.now - 3611) }

    it 'sends a notification' do
      contacts.first
    end
  end
end
