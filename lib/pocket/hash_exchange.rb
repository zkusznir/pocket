module Pocket
  class HashExchange < Exchange
    attr_reader :rating

    RATES = { "USD" => { "EUR" => 0.890238, "GBP" => 0.649583, "CHF" => 0.962485, "JPY" => 120.693999, "PLN" => 3.77295 },
              "EUR" => { "USD" => 1.12365, "GBP" => 0.729495, "CHF" => 1.08145, "JPY" => 135.7515, "PLN": 4.234502 },
              "GBP" => { "USD" => 1.54033, "EUR" => 1.37193, "CHF" => 1.4847, "JPY" => 186.395, "PLN": 5.811513 },
              "CHF" => { "USD" => 1.03777, "EUR" => 0.924086, "GBP" => 0.672857, "JPY" => 125.585, "PLN": 3.91255 },
              "JPY" => { "USD" => 0.00825559, "EUR" => 0.00735673, "GBP" => 0.00535834, "CHF" => 0.00796535, "PLN": 0.0311643 },
              "PLN" => { "USD" => 0.264943, "EUR" => 0.236082, "GBP" => 0.171955, "CHF" => 0.255571, "JPY" => 32.08396 } }

    def initialize
      @rating = Rating.new(RATES)
    end
  end
end
