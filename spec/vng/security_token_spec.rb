RSpec.describe Vng::SecurityToken do
  context 'with an invalid host' do
    before { Vng.configuration.host = 'invalid-host'}

    it 'raises an exception' do
      expect{Vng::SecurityToken.create}.to raise_error Vng::ConnectionError
    end
  end
end
