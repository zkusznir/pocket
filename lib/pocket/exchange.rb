require './lib/pocket/rating'
require './lib/pocket/invalid_currency'

module Pocket
  class Exchange
    def initialize
      @rating = Rating.new
    end

    def convert(money, currency)
      raise InvalidCurrency.new(currency) if !@rating.rates.has_key?(currency)
      money.value * @rating.rates[money.currency][currency]
    end
  end
end
