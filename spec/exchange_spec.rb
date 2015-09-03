require 'spec_helper'

describe Pocket::Exchange do
  let(:exchange) { Pocket::Exchange.new }
  let(:dollars) { Pocket::Money(10, 'USD') }

  describe '#convert' do
    it 'converts currencies' do
      expect(exchange.convert(dollars, 'EUR').to_s).to eq('8.90 EUR')
    end

    it 'raises an exception when invalid currency is passed' do
      expect { exchange.convert(dollars, 'CZK') }.to raise_error(Pocket::InvalidCurrency, /CZK/)
    end
  end
end
