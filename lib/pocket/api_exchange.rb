require 'net/http'
require 'json'

module Pocket
  class ApiExchange < Exchange

    API_URI = 'http://apilayer.net/api/live?access_key=e9ad14e831f0bacfd8e81182bd642252&currencies=EUR,GBP,CHF,JPY,PLN&source=USD&format=1'

    def initialize
      @rating = Rating.new
    end

    def convert(money, currency)
      rates = Hash.new
      fetch_rates.each do |currencies, value|
        rates[currencies[0..2]] ||= Hash.new
        rates[currencies[0..2]].merge!(currencies[3..5] => value)
      end
      @rating.set_rates(rates)
      super
    end

    def fetch_rates
      response = Net::HTTP.get_response(URI(API_URI))
      JSON.parse(response.body)['quotes']
    end
  end
end
