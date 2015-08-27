require 'spec_helper'

describe Pocket do
  let(:dollars) { Pocket::Money.new(10, 'USD') }
  let(:euros) { Pocket::Money.new(12.1, 'EUR') }

  context 'when money instance is created' do
    it 'stringifies value' do
      expect(dollars.to_s).to eq('10.00 USD')
      expect(euros.to_s).to eq('12.10 EUR')
    end

    it 'inspects value' do
      expect(dollars.inspect).to eq('#<Money 10.00 USD>')
      expect(euros.inspect).to eq('#<Money 12.10 EUR>')
    end
  end
end
