require "pocket/version"

module Pocket
  class Money
    class << self
      ['usd', 'eur', 'gbp'].each do |currency|
        define_method("from_#{currency}") { |value| Money.new(value, currency) }
      end
    end

    def initialize(value, currency)
      @value, @currency = value, currency.upcase
    end

    def to_s
      "#{"%0.2f" % @value} #{@currency}"
    end

    def inspect
      "#<Money #{to_s}>"
    end
  end
end
