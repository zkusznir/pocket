require "pocket/version"

module Pocket
  class Money
    def initialize(value, currency)
      @value, @currency = value, currency
    end

    def to_s
      "#{"%0.2f" % @value} #{@currency}"
    end

    def inspect
      "#<Money #{to_s}>"
    end
  end
end
