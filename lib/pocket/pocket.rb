require "pocket/version"
require 'exchange'

module Pocket
  class Money
    include Comparable

    attr_reader :value, :currency, :default_currency

    class << self
      ['usd', 'eur', 'gbp'].each do |currency|
        define_method("from_#{currency}") { |value| Money.new(value, currency) }
      end

      def using_default_currency(currency, &block)
        @default_currency = currency
      end
    end

    def initialize(value, currency)
      @value, @currency, @exchange = value, currency.upcase, Exchange.new
    end

    def <=>(another_money)
      exchange_to(another_money.currency) <=> another_money.value
    end

    def to_s
      "#{"%0.2f" % @value} #{@currency}"
    end

    def inspect
      "#<Money #{to_s}>"
    end

    def exchange_to(currency)
      @currency == currency ? @value : @exchange.convert(self, currency.upcase)
    end
  end

  def Pocket::Money(value, currency)
    Money.new(value, currency)
  end
end
