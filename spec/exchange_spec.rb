require 'spec_helper'
require 'webmock/rspec'

describe Pocket::Exchange do
  let(:dollars) { Pocket::Money(10, 'USD') }

  context 'when hash exchange is used' do
    let(:exchange) { Pocket::HashExchange.new }

    it 'converts currencies' do
      expect(exchange.convert(dollars, 'EUR').to_s).to eq('8.90 EUR')
    end

    it 'raises an exception when invalid currency is passed' do
      expect { exchange.convert(dollars, 'CZK') }.to raise_error(Pocket::InvalidCurrency, /CZK/)
    end
  end

  context 'when api rating is used' do
    let(:exchange) { Pocket::ApiExchange.new }

    it 'fetches rates' do
      stub_request(:any, Pocket::ApiExchange::API_URI).
        to_return(:body => %q({
          "success":true,
          "terms":"https:\/\/currencylayer.com\/terms",
          "privacy":"https:\/\/currencylayer.com\/privacy",
          "timestamp":1442588768,
          "source":"USD",
          "quotes":{
            "USDEUR":0.879693,
            "USDGBP":0.64154,
            "USDCHF":0.96107,
            "USDJPY":119.930496,
            "USDPLN":3.694602
          }
        }), :status => 200)
      expect(exchange.convert(dollars, 'EUR').to_s).to eq('8.80 EUR')
    end
  end
end
