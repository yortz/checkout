module Ecommerce
  class Checkout
    attr_accessor :rule, :cart, :total

    def initialize(rule)
      @rule = rule
      @cart = []
      @total = 0
    end

    def scan item
      @cart.push item
    end

    def total
      @total = @cart.map(&:price).reduce(:+)
    end
  end
end
