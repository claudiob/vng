RSpec.describe Vng::SecurityToken do
  context 'with an invalid host' do
    before { expect(Vng.configuration).to receive(:host).and_return 'invalid-host' }

    it 'raises an exception' do
      expect { Vng::SecurityToken.create }.to raise_error Vng::ConnectionError
    end

    context 'with ActiveSupport::Notifications' do
      before { require 'active_support/notifications' }

      it 'sends a notification' do
        expect(ActiveSupport::Notifications).to receive(:instrument).and_call_original
        expect { Vng::SecurityToken.create }.to raise_error Vng::ConnectionError
      end
    end
  end

  context 'with valid credentials' do
    let(:token) { Vng::SecurityToken.create }

    it 'does not raise an exception' do
      expect { token.destroy }.not_to raise_error
      expect { token.destroy }.not_to raise_error
    end
  end
end
