require './lib/pocket/version'
require './lib/pocket/exchange'
require 'bigdecimal'

module Pocket
  class Money
    include Comparable
    @@default_currency, @@exchange = nil, Exchange.new

    attr_reader :value, :currency

    class << self
      ['usd', 'eur', 'gbp'].each do |currency|
        define_method("from_#{currency}") { |value| Money.new(value, currency) }
      end

      def default_currency
        @@default_currency
      end

      def using_default_currency(currency, &block)
        outer_currency = @@default_currency
        @@default_currency = currency
        yield
      ensure
        @@default_currency = outer_currency
      end
    end

    def initialize(value, currency = nil)
      raise CurrencyMissing if Money.default_currency.nil? && currency.nil?
      currency = Money.default_currency if currency.nil?
      @value, @currency = BigDecimal.new(value.to_s, 2), currency.upcase
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
      @currency == currency ? self : @@exchange.convert(self, currency.upcase)
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s.start_with?('to_')
        currency = method_name.to_s.split('_').last.upcase
        super unless @@exchange.rating.rates.has_key?(currency)
        exchange_to(currency)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = true)
      method_name.to_s.start_with?('to_') || super
    end
  end

  def Pocket::Money(value, *currency)
    currency = currency.empty? ? nil : currency.first
    Money.new(value, currency)
  end
end
