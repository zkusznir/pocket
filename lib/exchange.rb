require 'rating'

class Exchange
  def initialize
    @rating = Rating.new
  end

  def convert(money, currency)
    money.value * @rating.rates[money.currency][currency.upcase]
  end
end
