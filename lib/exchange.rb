require 'rating'
require 'invalid_currency'

class Exchange
  def initialize
    @rating = Rating.new
  end

  def convert(money, currency)
    raise InvalidCurrency, "Invalid currency: #{currency}" if !@rating.rates.has_key?(currency)
    money.value * @rating.rates[money.currency][currency]
  end
end
