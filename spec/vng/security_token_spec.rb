RSpec.describe Vng::SecurityToken do
  context 'with an invalid host' do

    it 'raises an exception' do
      expect(Vng.configuration).to receive(:host).and_return 'invalid-host'

      expect{Vng::SecurityToken.create}.to raise_error Vng::ConnectionError
    end
  end
end
