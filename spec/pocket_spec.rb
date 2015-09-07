require 'spec_helper'

describe Pocket do
  let(:dollars) { Pocket::Money.new(10, 'USD') }
  let(:another_dollars) { Pocket::Money.new(50, 'USD') }
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

  describe '.Money' do
    it 'creates new instance' do
      expect(Pocket::Money(5, 'USD').to_s).to eq('5.00 USD')
    end
  end

  describe '#<=>' do
    it 'compares money instances of the same currency' do
      expect(dollars < another_dollars).to be true
    end

    it 'compares money instances of different currency' do
      expect(euros < another_dollars).to be true
    end
  end

  describe '.using_default_currency' do
    it 'creates new instance of parameters currency' do
      expect(Pocket::Money.using_default_currency('USD') { Pocket::Money(100) }.to_s)
        .to eq('100.00 USD')
      expect(Pocket::Money.using_default_currency('USD') { Pocket::Money.new(100) }.to_s)
        .to eq('100.00 USD')
    end

    it 'does not create new instanced when no default currency set' do
      expect { Pocket::Money(100) }.to raise_error(Pocket::CurrencyMissing)
      expect { Pocket::Money.new(100) }.to raise_error(Pocket::CurrencyMissing)
    end

    it 'creates an instance of specified currency even if created in block' do
      expect(Pocket::Money.using_default_currency('USD') { Pocket::Money.new(55, 'EUR') }.to_s)
        .to eq('55.00 EUR')
    end

    it 'ensures default currency is nullified after the block execution' do
      begin
        Money.using_default_currency('USD') do
          raise 'an_error'
        end
      rescue
      end
      expect { Pocket::Money.new(100) }.to raise_error(Pocket::CurrencyMissing)
    end

    it 'keeps the proper currency within each block' do
      Pocket::Money.using_default_currency('USD') do
        expect(Pocket::Money.new(100).to_s).to eq('100.00 USD')
        Pocket::Money.using_default_currency('EUR') do
          expect(Pocket::Money.new(55).to_s).to eq('55.00 EUR')
        end
        expect(Pocket::Money.new(100).to_s).to eq('100.00 USD')
      end
    end
  end

  describe 'nested .using_default_currency block' do
    it 'creates instances of different currencies' do
      money = Pocket::Money.using_default_currency('USD') do
        Pocket::Money.new(100)
        Pocket::Money.using_default_currency('EUR') { Pocket::Money.new(55) }
      end
      expect(money.to_s).to eq('55.00 EUR')
    end
  end
end
