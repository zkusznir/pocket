require 'spec_helper'

describe Exchange do
  let(:exchange) { Exchange.new }
  let(:dollars) { Pocket::Money(10, 'USD') }

  describe '#convert' do
    it 'converts currencies' do
      expect(exchange.convert(dollars, 'EUR')).to eq(10*0.890238)
    end

    it 'raises an exception when invalid currency is passed' do
      expect { exchange.convert(dollars, 'CZK') }.to raise_error('Invalid currency: CZK')
    end
  end
end
