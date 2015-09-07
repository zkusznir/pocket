require './lib/pocket/version'
require './lib/pocket/exchange'

module Pocket
  class Money
    include Comparable
    @@default_currency, @@outer_currency = nil, nil

    attr_reader :value, :currency

    class << self
      ['usd', 'eur', 'gbp'].each do |currency|
        define_method("from_#{currency}") { |value| Money.new(value, currency) }
      end

      def default_currency
        @@default_currency
      end

      def using_default_currency(currency, &block)
        @@outer_currency = @@default_currency
        @@default_currency = currency
        result = yield
      ensure
        @@default_currency = @@outer_currency.nil? ? nil : @@outer_currency
        result
      end
    end

    def initialize(value, currency = nil)
      raise CurrencyMissing if Money.default_currency.nil? && currency.nil?
      currency = Money.default_currency if currency.nil?
      @value, @currency, @exchange = value, currency.upcase, Exchange.new
    end

    def <=>(another_money)
      exchange_to(another_money.currency).value <=> another_money.value
    end

    def to_s
      "#{"%0.2f" % @value} #{@currency}"
    end

    def inspect
      "#<Money #{to_s}>"
    end

    def exchange_to(currency)
      @currency == currency ? self : @exchange.convert(self, currency.upcase)
    end
  end

  def Pocket::Money(value, *currency)
    currency = currency.empty? ? nil : currency.first
    Money.new(value, currency)
  end
end
