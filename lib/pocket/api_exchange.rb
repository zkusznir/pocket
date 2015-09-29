require 'net/http'
require 'json'
require 'api_cache'

module Pocket
  class ApiExchange < Exchange

    CURRENCIES = ['EUR', 'GBP', 'CHF', 'JPY', 'PLN']
    API_URI = "http://apilayer.net/api/live?access_key=e9ad14e831f0bacfd8e81182bd642252&currencies=#{CURRENCIES.join(',')}&source=USD&format=1"

    def initialize
      @rating = Rating.new
    end

    def convert(money, currency)
      rates = Hash.new
      fetch_rates.each do |currencies, value|
        rates[currencies[0..2]] ||= Hash.new
        rates[currencies[0..2]].merge!(currencies[3..5] => value)
      end
      rates.merge!(calculate_missing_rates(rates.values.first))
      @rating.set_rates(rates)
      super
    end

    def fetch_rates
      response = APICache.get(API_URI, cache: 600 )
      JSON.parse(response)['quotes']
    end

    def calculate_missing_rates(usd_rates)
      missing_rates = Hash.new
      usd_rates.each do |currency, rate|
        missing_rates[currency] = Hash.new
        missing_rates[currency].merge!('USD' => 1/rate)
        usd_rates.each { |c, r| missing_rates[currency].merge!(c => r/rate) if currency != c }
      end
      missing_rates
    end
  end
end
