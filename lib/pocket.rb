require "pocket/version"
require 'exchange'

module Pocket
  class Money
    attr_reader :value, :currency
    
    class << self
      ['usd', 'eur', 'gbp'].each do |currency|
        define_method("from_#{currency}") { |value| Money.new(value, currency) }
      end
    end

    def initialize(value, currency)
      @value, @currency, @exchange = value, currency.upcase, Exchange.new
    end

    def to_s
      "#{"%0.2f" % @value} #{@currency}"
    end

    def inspect
      "#<Money #{to_s}>"
    end

    def exchange_to(currency)
      @exchange.convert(self, currency)
    end
  end
end
