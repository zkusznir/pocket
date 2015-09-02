module Pocket
  class InvalidCurrency < StandardError

    def initialize(message)
      super("Invalid currency: #{message}")
    end
  end
end
