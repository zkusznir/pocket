module Pocket
  class InvalidCurrency < StandardError

    def initialize(message)
      super("Invalid currency: #{message}")
    end
  end

  class CurrencyMissing < StandardError

    def initialize
      super('No currency specified')
    end
  end
end
