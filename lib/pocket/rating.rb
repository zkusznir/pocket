module Pocket
  class Rating
    attr_reader :rates
    
    def initialize(rates = nil)
      set_rates(rates)
    end

    def set_rates(rates)
      @rates = rates
    end
  end
end
