require_relative './rating'
require_relative './invalid_currency'

module Pocket
  class Exchange
    def convert(money, currency)
      raise InvalidCurrency.new(currency) unless valid_conversion?(money.currency, currency)
      Money.new(money.value * @rating.rates[money.currency][currency], currency)
    end

    def valid_currency?(currency)
      @rating.rates.has_key?(currency)
    end

    def valid_conversion?(from_currency, to_currency)
      @rating.rates[from_currency].has_key?(to_currency)
    end
  end
end
