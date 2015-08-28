require 'spec_helper'

describe Pocket do
  let(:dollars) { Pocket::Money.new(10, 'USD') }
  let(:euros) { Pocket::Money.new(12.1, 'EUR') }

  describe '#initialize' do
    it 'stringifies value' do
      expect(dollars.to_s).to eq('10.00 USD')
      expect(euros.to_s).to eq('12.10 EUR')
    end

    it 'inspects value' do
      expect(dollars.inspect).to eq('#<Money 10.00 USD>')
      expect(euros.inspect).to eq('#<Money 12.10 EUR>')
    end
  end

  describe '.from_currency' do
    it 'creates new instance' do
      expect(Pocket::Money.from_eur(15).to_s).to eq('15.00 EUR')
    end
  end

  describe '#exchange_to' do
    it 'converts currencies' do
      expect(dollars.exchange_to('EUR')).to eq(10*0.890238)
    end
  end

  describe '.Money' do
    it 'creates new instance' do
      expect(Pocket::Money(5, 'USD').to_s).to eq('5.00 USD')
    end
  end
end
