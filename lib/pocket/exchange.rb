require_relative './rating'
require_relative './invalid_currency'

module Pocket
  class Exchange
    attr_reader :rating

    def initialize
      @rating = Rating.new
    end

    def convert(money, currency)
      raise InvalidCurrency.new(currency) if !@rating.rates.has_key?(currency)
      Money.new(money.value * @rating.rates[money.currency][currency], currency)
    end
  end
end
